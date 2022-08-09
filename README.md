# multi-tenant-gke-cluster
Terraform and Kubernetes code to provision a mutli region, multi tenant GKE cluster.

# 1) Authenticate GKE Cluster from GCloud CLI
gcloud container clusters get-credentials CLUSTER_NAME --region REGION_NAME


# 2) Generate SSH Key
ssh-keygen -t rsa -b 4096 \
-C "GIT_REPOSITORY_USERNAME" \
-N '' \
-f /path/to/KEYPAIR_FILENAME

# 3) Create ACM Namespace and create git ssh secret
kubectl create ns config-management-system && \
kubectl create secret generic git-creds \
 --namespace=config-management-system \
 --from-file=ssh=/path/to/KEYPAIR_PRIVATE_KEY_FILENAME

# 4) Add the .pub key into your Git platform account

# 5) Repeast steps 1 and 3 for all the GKE Clusters
