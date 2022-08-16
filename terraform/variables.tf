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


variable "clusters" {
  description = "GKE Clusters params"
  type = list(object({
    cluster_location         = string
    subnetwork               = string
    secondary_range_pods     = string
    secondary_range_services = string
    master_ipv4_cidr_block   = string
  }))
}

variable "cluster_name" {
  description = "GKE Cluster Name"
  type        = string
  default     = "multitenant-gke-cluster"
}

variable "project_id" {
  description = "Project ID in which GKE Cluster will be created"
  type        = string
}


variable "master_authorized_ranges" {
  description = "External Ip address ranges that can access the Kubernetes cluster master through HTTPS.."
  type        = map(string)
  default = {
    "public" = "0.0.0.0/0"
  }
}

variable "horizontal_pod_autoscaling" {
  description = "Enable / Disable Horizontal Pod Autoscaling"
  type        = bool
  default     = true
}

variable "cluster_description" {
  description = "Cluster description"
  type        = string
  default     = "GKE multi region cluster"
}

variable "labels" {
  description = "Cluster resource labels."
  type        = map(string)
  default     = { "env" : "test" }
}

variable "network" {
  description = "VPC Network where GKE Clusters will be launched"
  type        = string
}

variable "cluster_autoscale_cpu_min" {
  description = "Min. CPU for cluster autoscaling"
  type        = number
  default     = 20
}

variable "cluster_autoscale_cpu_max" {
  description = "Max. CPU for cluster autoscaling"
  type        = number
  default     = 80
}

variable "cluster_autoscale_mem_min" {
  description = "Min. memory for cluster autoscaling"
  type        = number
  default     = 2048
}

variable "cluster_autoscale_mem_max" {
  description = "Max. memory for cluster autoscaling"
  type        = number
  default     = 4096
}

variable "enable_binary_authorization" {
  description = "Enable Binary Authorization"
  type        = bool
  default     = false
}

variable "default_max_pods_per_node" {
  description = "Max no. of pods per node"
  type        = number
  default     = 100
}


variable "nodepool_node_count" {
  description = "Nodepool Node Count"
  type        = number
  default     = 5
}

variable "autoscale_nodepool_min_node_count" {
  description = "Nodepool Min. Node Count"
  type        = number
  default     = 5
}

variable "autoscale_nodepool_max_node_count" {
  description = "Nodepool Max. Node Count"
  type        = number
  default     = 20
}

variable "sync_repo" {
  description = "Sync repo"
  type        = string
  default     = "https://github.com/GKE-Accelerators/multi-tenant-gke-cluster"
}

variable "sync_branch" {
  description = "Sync Branch"
  type        = string
  default     = "main"
}

variable "policy_dir" {
  description = "Policy Directory"
  type        = string
  default     = "config"
}
