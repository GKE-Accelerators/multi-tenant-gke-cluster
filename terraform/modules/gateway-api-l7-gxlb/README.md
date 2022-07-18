# Gateway API module
This module can be used to activate GXLB through the Gateway API to a given gke cluster.

To use this module you must ensure the following APIs are enabled in the target project:
```
"container.googleapis.com"
"gkehub.googleapis.com"
"gkeconnect.googleapis.com"
"anthosconfigmanagement.googleapis.com"
"multiclusteringress.googleapis.com"
"multiclusterservicediscovery.googleapis.com"
"trafficdirector.googleapis.com"
```

## Disclaimer
- This module uses [kubernetes provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs), the usage follow its own license.
- Gateway API CRDs should be managed manually, the files store under CRD folder are place ONLY for demo purpose. Please, refer to the [official repo](github.com/kubernetes-sigs/gateway-api/)
- Connect the gateway-api-l7-gxlb module with the gateway-api module to ensure consistency

## Usage example

```hcl
module "gke-gateway-api" {
  source         = "./modules/gateway-api"
  endpoint       = module.gke_1.endpoint
  ca_certificate = module.gke_1.ca_certificate
}

module "gke-gateway-api-demo" {
  source              = "./modules/gateway-api-l7-gxlb"
  endpoint            = module.gke_1.endpoint
  ca_certificate      = module.gke_1.ca_certificate
  gateway_api_version = module.gke-gateway-api.version
}
```