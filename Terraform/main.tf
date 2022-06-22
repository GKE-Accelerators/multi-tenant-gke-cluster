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
  for_each                 = var.clusters
  project_id               = each.value.project_id
  name                     = each.key
  description              = each.value.cluster_description
  location                 = each.value.cluster_location
  labels                   = each.value.labels
  network                  = each.value.network
  subnetwork               = each.value.subnetwork
  secondary_range_pods     = each.value.secondary_range_pods
  secondary_range_services = each.value.secondary_range_services
  cluster_autoscaling = {
    enabled    = true
    cpu_min    = each.value.cluster_autoscaling.cpu_min
    cpu_max    = each.value.cluster_autoscaling.cpu_max
    memory_min = each.value.cluster_autoscaling.memory_min
    memory_max = each.value.cluster_autoscaling.memory_max
  }
  addons = {
    cloudrun_config                       = false
    dns_cache_config                      = true
    http_load_balancing                   = true
    gce_persistent_disk_csi_driver_config = true
    horizontal_pod_autoscaling            = each.value.horizontal_pod_autoscaling
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
    enable_private_nodes    = each.value.private_cluster_config.enable_private_nodes
    enable_private_endpoint = each.value.private_cluster_config.enable_private_endpoint
    master_ipv4_cidr_block  = each.value.private_cluster_config.master_ipv4_cidr_block
    master_global_access    = each.value.private_cluster_config.master_global_access
  }
  logging_config    = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  monitoring_config = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  database_encryption = (
    each.value.database_encryption_key == null ? {
      enabled  = false
      state    = null
      key_name = null
      } : {
      enabled  = true
      state    = "ENCRYPTED"
      key_name = each.value.database_encryption_key
    }
  )
  default_max_pods_per_node   = each.value.default_max_pods_per_node
  enable_binary_authorization = each.value.enable_binary_authorization
  master_authorized_ranges    = each.value.master_authorized_ranges
  vertical_pod_autoscaling    = each.value.vertical_pod_autoscaling
}