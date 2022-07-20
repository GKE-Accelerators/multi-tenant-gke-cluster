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

variable "project_id" {
  description = "Project ID in which GKE Cluster will be created"
  type        = string
}


variable "master_authorized_ranges" {
  description = "External Ip address ranges that can access the Kubernetes cluster master through HTTPS.."
  type        = map(string)
}

variable "horizontal_pod_autoscaling" {
  description = "Enable / Disable Horizontal Pod Autoscaling"
  type        = bool
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "cluster_description" {
  description = "Cluster description"
  type        = string
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
  type        = string
}

variable "cluster_autoscale_cpu_max" {
  description = "Max. CPU for cluster autoscaling"
  type        = string
}

variable "cluster_autoscale_mem_min" {
  description = "Min. memory for cluster autoscaling"
  type        = string
}

variable "cluster_autoscale_mem_max" {
  description = "Max. memory for cluster autoscaling"
  type        = string
}

variable "enable_binary_authorization" {
  description = "Enable Binary Authorization"
  type        = bool
}

variable "default_max_pods_per_node" {
  description = "Max no. of pods per node"
  type        = number
}

variable "sync_repo" {
  description = "Sync repo"
  type        = string
}

variable "sync_branch" {
  description = "Sync Branch"
  type        = string
}

variable "policy_dir" {
  description = "Policy Directory"
  type        = string
}
