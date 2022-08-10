# multi-tenant-gke-cluster
Terraform and Kubernetes code to provision a mutli region, multi tenant GKE cluster.

### 1) Authenticate GKE Cluster from GCloud CLI
gcloud container clusters get-credentials CLUSTER_NAME --region REGION_NAME


### 2) Generate SSH Key
ssh-keygen -t rsa -b 4096 \
-C "GIT_REPOSITORY_USERNAME" \
-N '' \
-f /path/to/KEYPAIR_FILENAME

### 3) Create ACM Namespace and create git ssh secret
kubectl create ns config-management-system && \
kubectl create secret generic git-creds \
 --namespace=config-management-system \
 --from-file=ssh=/path/to/KEYPAIR_PRIVATE_KEY_FILENAME

### 4) Add the .pub key into your Git platform account
cat KEY_NAME.pub and copy the contents manually in your account in the respective Git Platform

### 5) Repeat steps 1 and 3 for all the GKE Clusters
For Eg: if you have 2 clusters in europe-west3 and us-east4 respectively then repeat the steps 1 and 3 to authenticate the cluster from your cloud shell and then create the namespace and secret for Anthos Config management to pull your cluster configuration