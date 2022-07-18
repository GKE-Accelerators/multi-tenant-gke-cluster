# GKE-Cluster-with-add-ons
<!-- BEGIN_TF_DOCS -->
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

## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke-cluster"></a> [gke-cluster](#module\_gke-cluster) | github.com/terraform-google-modules/cloud-foundation-fabric//modules/gke-cluster | v15.0.0 |
| [acm](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest/submodules/acm) | terraform-google-modules/kubernetes-engine/google//modules/acm | 21.1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_autoscaling"></a> [cluster\_autoscaling](#input\_cluster\_autoscaling) | Enable and configure limits for Node Auto-Provisioning with Cluster Autoscaler. | <pre>object({<br>    enabled    = bool<br>    cpu_min    = number<br>    cpu_max    = number<br>    memory_min = number<br>    memory_max = number<br>  })</pre> | <pre>{<br>  "cpu_max": 0,<br>  "cpu_min": 0,<br>  "enabled": false,<br>  "memory_max": 0,<br>  "memory_min": 0<br>}</pre> | no |
| <a name="input_cluster_description"></a> [cluster\_description](#input\_cluster\_description) | Cluster description. | `string` | n/a | yes |
| <a name="input_cluster_location"></a> [cluster\_location](#input\_cluster\_location) | Cluster zone or region. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Cluster name. | `string` | n/a | yes |
| <a name="input_database_encryption_key"></a> [database\_encryption\_key](#input\_database\_encryption\_key) | Database Encryption Key name to	enable and configure GKE application-layer secrets encryption. | `string` | n/a | yes |
| <a name="input_enable_binary_authorization"></a> [enable\_binary\_authorization](#input\_enable\_binary\_authorization) | Enable Google Binary Authorization. | `bool` | n/a | yes |
| <a name="input_horizontal_pod_autoscaling"></a> [horizontal\_pod\_autoscaling](#input\_horizontal\_pod\_autoscaling) | Set to true to enable horizontal pod autoscaling | `bool` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Cluster resource labels. | `map(string)` | n/a | yes |
| <a name="input_master_authorized_ranges"></a> [master\_authorized\_ranges](#input\_master\_authorized\_ranges) | External Ip address ranges that can access the Kubernetes cluster master through HTTPS.. | `map(string)` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | Name or self link of the VPC used for the cluster. Use the self link for Shared VPC. | `string` | n/a | yes |
| <a name="input_private_cluster_config"></a> [private\_cluster\_config](#input\_private\_cluster\_config) | Enable and configure private cluster, private nodes must be true if used. | <pre>object({<br>    enable_private_nodes    = bool<br>    enable_private_endpoint = bool<br>    master_ipv4_cidr_block  = string //The IP range in CIDR notation to use for the hosted master network<br>    master_global_access    = bool<br>  })</pre> | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GKE Cluster project id. | `string` | n/a | yes |
| <a name="input_secondary_range_pods"></a> [secondary\_range\_pods](#input\_secondary\_range\_pods) | Subnet secondary range name used for pods. | `string` | n/a | yes |
| <a name="input_secondary_range_services"></a> [secondary\_range\_services](#input\_secondary\_range\_services) | Subnet secondary range name used for pods. | `string` | n/a | yes |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | VPC subnetwork name or self link. | `string` | n/a | yes |
| <a name="input_vertical_pod_autoscaling"></a> [vertical\_pod\_autoscaling](#input\_vertical\_pod\_autoscaling) | Set to true to enable vertical pod autoscaling | `bool` | n/a | yes |
| sync_repo | ACM Git repo address	 | `string` | `https://github.com/GoogleCloudPlatform/acm-essentials` | yes |
| sync_branch | ACM repo Git branch. If un-set, uses Config Management default. | `string` | "" | optional |
| policy_dir | ACM repo Git revision. If un-set, uses Config Management default. | `string` | "" | optional |

## Outputs

No outputs.
| Name | Description | 
|------|-------------|
| gke-endpoint | GKE controller endpoint | 
| git-creds-public | Git credentails to be added to repo to be used to manage the configuration files for ACM| 
