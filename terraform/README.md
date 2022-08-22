# GKE Multi Tenant Cluster

Copyright 2022 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Introduction 
This document describes a multi tenant GKE architecture. The blueprint helps you deploy multiple regional GKE clusters in different regions , registers all clusters to GKE Hub & Anthos Configuration Management and sets up config sync. 

This repo contains the following
(Terraform code)[] 
Kubernetes config files

## Architecture
![architecture diagram](https://raw.githubusercontent.com/GKE-Accelerators/multi-tenant-gke-cluster/main/terraform/multi_tenant_gke_cluster.png "Figure 1")

In this diagram, we have an architecture of multiple GKE regional clusters deployed across two different regions in two different subnets within same Shared VPC, and also registered to GKE Hub and Anthos Configuration management to use policy controller.


The architecture is of multi-tenant GKE clusters. As shown in the diagram in the preceding section this architecture creates and configures the following resources
- Multiple regional GKE clusters with with optional add-ons
- Integration of GKE Clusters to GKE Hub and registering them to Anthos Config Management along with Git repository integration with ACM
- Sample Namespaces via config files residing in the config/ folder in the repository - https://github.com/GKE-Accelerators/multi-tenant-gke-cluster


## Pre-requisites
The architecture assumes that the following configuration is already in place and will be dependent on these resources to work as expected.

### Network
**Shared VPC** - The architecture is based on the assumption that there is a shared VPC already configured and is available and the account used to create the resources have all the required permissions required to deploy the components in the architecture.

**Subnet** - We need a subnet for the cluster nodes to be deployed in the respective region. The subnet should also have 2 secondary subnets that are to be used for the pod and services.

**CIDR range** - Determine a CIDR range to be assigned to the master node.  

**KMS** - Incase of a requirement for encrypting the data on the cluster a KMS key is required to be created and configured to be used in the cluster.

### API
Ensure that all the APIs listed below are enabled in the project where the GKE cluster needs to be deployed

- `anthos.googleapis.com`
- `gkehub.googleapis.com`
- `anthosconfigmanagement.googleapis.com`
- `container.googleapis.com`
- `gkeconnect.googleapis.com`
- `multiclusteringress.googleapis.com`
- `multiclusterservicediscovery.googleapis.com`
- `trafficdirector.googleapis.com`


### Roles
The Below listed roles should be assigned to the account that will be used to provision the resources that are defined in the architecture. 

- `roles/container.clusterAdmin`
- `roles/iam.serviceAccountUser`
- `roles/iam.serviceAccountAdmin`
- `roles/compute.networkUser`
- `roles/container.developer`
- `roles/serviceusage.serviceUsageAdmin`
- `roles/gkehub.admin`
- `roles/compute.instanceAdmin`

## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke-cluster"></a> [gke-cluster](#module\_gke-cluster) | github.com/terraform-google-modules/cloud-foundation-fabric//modules/gke-cluster | v15.0.0 |
| <a name="module_gke-hub"></a> [gke-hub](#module\_gke-hub) | github.com/terraform-google-modules/cloud-foundation-fabric//modules/gke-hub | n/a |
| <a name="module_nodepool"></a> [nodepool](#module\_nodepool) | github.com/terraform-google-modules/cloud-foundation-fabric//modules/gke-nodepool | v15.0.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscale_nodepool_max_node_count"></a> [autoscale\_nodepool\_max\_node\_count](#input\_autoscale\_nodepool\_max\_node\_count) | Nodepool Max. Node Count | `number` | `20` | no |
| <a name="input_autoscale_nodepool_min_node_count"></a> [autoscale\_nodepool\_min\_node\_count](#input\_autoscale\_nodepool\_min\_node\_count) | Nodepool Min. Node Count | `number` | `5` | no |
| <a name="input_cluster_autoscale_cpu_max"></a> [cluster\_autoscale\_cpu\_max](#input\_cluster\_autoscale\_cpu\_max) | Max. CPU for cluster autoscaling | `number` | `80` | no |
| <a name="input_cluster_autoscale_cpu_min"></a> [cluster\_autoscale\_cpu\_min](#input\_cluster\_autoscale\_cpu\_min) | Min. CPU for cluster autoscaling | `number` | `20` | no |
| <a name="input_cluster_autoscale_mem_max"></a> [cluster\_autoscale\_mem\_max](#input\_cluster\_autoscale\_mem\_max) | Max. memory for cluster autoscaling | `number` | `4096` | no |
| <a name="input_cluster_autoscale_mem_min"></a> [cluster\_autoscale\_mem\_min](#input\_cluster\_autoscale\_mem\_min) | Min. memory for cluster autoscaling | `number` | `2048` | no |
| <a name="input_cluster_description"></a> [cluster\_description](#input\_cluster\_description) | Cluster description | `string` | `"GKE multi region cluster"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | GKE Cluster Name | `string` | `"multitenant-gke-cluster"` | no |
| <a name="input_clusters"></a> [clusters](#input\_clusters) | GKE Clusters params | <pre>list(object({<br>    cluster_location         = string<br>    subnetwork               = string<br>    secondary_range_pods     = string<br>    secondary_range_services = string<br>    master_ipv4_cidr_block   = string<br>  }))</pre> | n/a | yes |
| <a name="input_default_max_pods_per_node"></a> [default\_max\_pods\_per\_node](#input\_default\_max\_pods\_per\_node) | Max no. of pods per node | `number` | `100` | no |
| <a name="input_enable_binary_authorization"></a> [enable\_binary\_authorization](#input\_enable\_binary\_authorization) | Enable Binary Authorization | `bool` | `false` | no |
| <a name="input_horizontal_pod_autoscaling"></a> [horizontal\_pod\_autoscaling](#input\_horizontal\_pod\_autoscaling) | Enable / Disable Horizontal Pod Autoscaling | `bool` | `true` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Cluster resource labels. | `map(string)` | <pre>{<br>  "env": "test"<br>}</pre> | no |
| <a name="input_master_authorized_ranges"></a> [master\_authorized\_ranges](#input\_master\_authorized\_ranges) | External Ip address ranges that can access the Kubernetes cluster master through HTTPS.. | `map(string)` | <pre>{<br>  "public": "0.0.0.0/0"<br>}</pre> | no |
| <a name="input_network"></a> [network](#input\_network) | VPC Network where GKE Clusters will be launched | `string` | n/a | yes |
| <a name="input_nodepool_node_count"></a> [nodepool\_node\_count](#input\_nodepool\_node\_count) | Nodepool Node Count | `number` | `5` | no |
| <a name="input_policy_dir"></a> [policy\_dir](#input\_policy\_dir) | Policy Directory | `string` | `"config"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID in which GKE Cluster will be created | `string` | n/a | yes |
| <a name="input_sync_branch"></a> [sync\_branch](#input\_sync\_branch) | Sync Branch | `string` | `"main"` | no |
| <a name="input_sync_repo"></a> [sync\_repo](#input\_sync\_repo) | Sync repo | `string` | `"https://github.com/GKE-Accelerators/multi-tenant-gke-cluster"` | no |

## Outputs

No outputs.
