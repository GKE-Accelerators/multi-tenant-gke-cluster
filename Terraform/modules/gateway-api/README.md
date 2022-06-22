# Gateway API module
This module can be used to activate Gateway API CRDs 0.4.3alpha1 v0.4.3alpha2 to a given gke cluster.

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
- This module uses [kubectl provider](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs), the usage follow its own license.
- Gateway API CRDs should be managed manually, the files store under CRD folder are place ONLY for demo purpose. Please, refer to the [official repo](github.com/kubernetes-sigs/gateway-api/)

## Usage example

```hcl
module "gke-gateway-api" {
  source         = "./modules/gateway-api"
  endpoint       = module.gke_1.endpoint
  ca_certificate = module.gke_1.ca_certificate
}
```