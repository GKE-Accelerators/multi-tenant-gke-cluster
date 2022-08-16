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




module "gke-cluster" {
  source                   = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/gke-cluster?ref=v15.0.0"
  for_each                 = { for cluster in var.clusters : cluster.cluster_location => cluster }
  project_id               = var.project_id
  name                     = join("-", tolist([var.cluster_name, each.value.cluster_location]))
  description              = var.cluster_description
  location                 = each.value.cluster_location
  labels                   = var.labels
  network                  = var.network
  subnetwork               = each.value.subnetwork
  secondary_range_pods     = each.value.secondary_range_pods
  secondary_range_services = each.value.secondary_range_services
  cluster_autoscaling = {
    enabled    = true
    cpu_min    = var.cluster_autoscale_cpu_min
    cpu_max    = var.cluster_autoscale_cpu_max
    memory_min = var.cluster_autoscale_mem_min
    memory_max = var.cluster_autoscale_mem_max
  }
  addons = {
    cloudrun_config                       = false
    dns_cache_config                      = true
    http_load_balancing                   = true
    gce_persistent_disk_csi_driver_config = true
    horizontal_pod_autoscaling            = var.horizontal_pod_autoscaling
    config_connector_config               = true
    kalm_config                           = false
    gcp_filestore_csi_driver_config       = false
    network_policy_config                 = false
    istio_config = {
      enabled = false
      tls     = false
    }
  }
  private_cluster_config = {
    enable_private_nodes    = false
    enable_private_endpoint = false
    master_ipv4_cidr_block  = each.value.master_ipv4_cidr_block
    master_global_access    = false
  }
  logging_config              = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  monitoring_config           = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  default_max_pods_per_node   = var.default_max_pods_per_node
  enable_binary_authorization = var.enable_binary_authorization
  master_authorized_ranges    = var.master_authorized_ranges
}

module "nodepool" {
  source                      = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/gke-nodepool?ref=v15.0.0"
  for_each                    = { for cluster in var.clusters : cluster.cluster_location => cluster }
  project_id                  = var.project_id
  cluster_name                = module.gke-cluster[each.value.cluster_location].name
  location                    = module.gke-cluster[each.value.cluster_location].location
  name                        = join("-", tolist([module.gke-cluster[each.value.cluster_location].name, "np"]))
  node_service_account_create = true
  node_count                  = var.nodepool_node_count
  autoscaling_config = {
    min_node_count = var.autoscale_nodepool_min_node_count
    max_node_count = var.autoscale_nodepool_max_node_count
  }
}

module "gke-hub" {
  source     = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/gke-hub"
  project_id = var.project_id
  clusters = {
    for cluster in var.clusters : cluster.cluster_location => module.gke-cluster[cluster.cluster_location].id
  }
  features = {
    appdevexperience             = false
    configmanagement             = true
    identityservice              = false
    multiclusteringress          = null
    servicemesh                  = false
    multiclusterservicediscovery = false
  }
  configmanagement_templates = {
    default = {
      binauthz = false
      config_sync = {
        git = {
          gcp_service_account_email = null
          https_proxy               = null
          policy_dir                = var.policy_dir
          secret_type               = "ssh"
          source_format             = "hierarchy"
          sync_branch               = var.sync_branch
          sync_repo                 = var.sync_repo
          sync_rev                  = null
          sync_wait_secs            = null
        }
        prevent_drift = false
        source_format = "hierarchy"
      }
      hierarchy_controller = null
      policy_controller = {
        audit_interval_seconds = 120
        exemptable_namespaces = [
          "asm-system",
          "config-management-system",
          "config-management-monitoring",
          "gatekeeper-system",
          "kube-system",
          "cos-auditd"
        ]
        log_denies_enabled         = true
        referential_rules_enabled  = false
        template_library_installed = true
      }
      version = "1.12.0"
    }
  }
  configmanagement_clusters = {
    "default" = [for cluster in var.clusters : cluster.cluster_location]
  }
}