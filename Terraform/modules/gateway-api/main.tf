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

locals {
  crd_0_3_0_dir = "${path.module}/crd/v0.3.0/bases"
  crd_0_4_3_dir = "${path.module}/crd/v0.4.3"
}

data "kubectl_path_documents" "v0-4-3-alpha2" {
  pattern = "${local.crd_0_4_3_dir}/v1alpha2/*.yaml"
}

data "kubectl_path_documents" "v0-4-3-alpha1" {
  pattern = "${local.crd_0_4_3_dir}/v1alpha1/*.yaml"
}

data "kubectl_path_documents" "v0-3-0" {
  pattern = "${local.crd_0_3_0_dir}/*.yaml"
}

data "google_client_config" "default" {}

provider "kubectl" {
  host                   = "https://${var.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(var.ca_certificate)
  apply_retry_count      = 3
  load_config_file       = false
}

resource "kubectl_manifest" "v0-4-3_alpha2" {
  for_each   = toset(data.kubectl_path_documents.v0-4-3-alpha2.documents)
  yaml_body  = each.value
  apply_only = true
}

resource "kubectl_manifest" "v0-4-3_alpha1" {
  for_each   = toset(data.kubectl_path_documents.v0-4-3-alpha1.documents)
  yaml_body  = each.value
  apply_only = true
  depends_on = [
    kubectl_manifest.v0-4-3_alpha2
  ]
}
