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
  cluster_location = [for cluster in var.clusters : cluster.cluster_location]
} // Returns list of cluster locations

module "gke-cluster" {
  source                   = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/gke-cluster?ref=v15.0.0"
  for_each                 = { for cluster in var.clusters : cluster.cluster_location => cluster }
  project_id               = each.value.project_id
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
  project_id                  = each.value.project_id
  cluster_name                = module.gke-cluster[each.value.cluster_location].name
  location                    = module.gke-cluster[each.value.cluster_location].location
  name                        = join("-", tolist([module.gke-cluster[each.value.cluster_location].name, "np"]))
  node_service_account_create = true
  node_count                  = 5
  autoscaling_config = {
    min_node_count = 5
    max_node_count = 20
  }
}

module "gke-gateway-api" {
  source         = "./modules/gateway-api"
  for_each       = { for cluster in var.clusters : cluster.cluster_location => cluster }
  endpoint       = module.gke-cluster[each.value.cluster_location].endpoint
  ca_certificate = module.gke-cluster[each.value.cluster_location].ca_certificate
}

# Register the cluster to Anthos configuration manager
data "google_client_config" "default" {}

provider "kubernetes" {
  count                  = length(local.cluster_location)
  host                   = "https://${module.gke-cluster[count.index].endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke-cluster[count.index].ca_certificate)
}

module "acm" {
  source       = "terraform-google-modules/kubernetes-engine/google//modules/acm"
  for_each     = { for cluster in var.clusters : cluster.cluster_location => cluster }
  project_id   = var.project_id
  cluster_name = module.gke-cluster[each.value.cluster_location].name
  location     = module.gke-cluster[each.value.cluster_location].location
  sync_repo    = var.sync_repo
  sync_branch  = var.sync_branch
  policy_dir   = var.policy_dir

  depends_on = [module.nodepool]
}