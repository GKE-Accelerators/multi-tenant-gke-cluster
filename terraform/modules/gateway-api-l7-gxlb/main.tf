/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${var.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(var.ca_certificate)
}

resource "kubernetes_namespace" "demo-gw" {
  metadata {
    name = "demo-gw"
  }
}

resource "kubernetes_deployment" "store" {
  metadata {
    name      = "store-v1"
    namespace = kubernetes_namespace.demo-gw.metadata.0.name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app     = "store"
        version = "v1"
      }
    }
    template {
      metadata {
        labels = {
          app     = "store"
          version = "v1"
        }
      }
      spec {
        container {
          image = "gcr.io/google-samples/whereami:v1.2.1"
          name  = "whereami"
          port {
            container_port = 8080
          }
          env {
            name  = "METADATA"
            value = "store-v1"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "store-svc" {
  metadata {
    name      = "store-v1"
    namespace = kubernetes_namespace.demo-gw.metadata.0.name
    annotations = {
      "networking.gke.io/max-rate-per-endpoint" = "10"
    }
  }
  spec {
    selector = {
      app     = kubernetes_deployment.store.spec.0.template.0.metadata.0.labels.app
      version = kubernetes_deployment.store.spec.0.template.0.metadata.0.labels.version
    }
    port {
      port        = 8080
      target_port = 8080
    }
  }
}

resource "kubernetes_manifest" "store-gw" {
  manifest = yamldecode(<<YAML
    kind: Gateway
    apiVersion: gateway.networking.k8s.io/v1alpha2
    metadata:
      name: store
      namespace: demo-gw
    spec:
      gatewayClassName: gke-l7-gxlb
      listeners:
      - name: http
        protocol: HTTP
        port: 80
        allowedRoutes:
          kinds:
          - kind: HTTPRoute
    YAML
  )
}

resource "kubernetes_manifest" "store-route" {
  manifest = yamldecode(<<YAML
    kind: HTTPRoute
    apiVersion: gateway.networking.k8s.io/v1alpha2
    metadata:
      name: public-store-route
      namespace: demo-gw
      labels:
        gateway: store
    spec:
      hostnames:
        - "demo.example.com"
      parentRefs:
      - name: store
      rules:
      - backendRefs:
        - name: store-v1
          port: 8080
    YAML
  )
}
