# challenge 1

Here I am going to use the AKS to setup the 3-tier architecture. Here each micro-service has its own service created and traffic would be directed to them based on the Ingress rules. Here front end running the React Js code and backend running on Node Js code and database as Azure PostgreSQL.


### Install Ingress controller Internal Load Balancer 

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

helm install ingress-nginx  ingress-nginx/ingress-nginx \
  --set controller.replicaCount=2 \ 
  --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \ 
  --set defaultBackend.nodeSelector."beta\.kubernetes\.io\/os"=linux \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal"="true"
```


### Prerequisites

+ Service pricipal with contribuor level access.
+ Storage account to save the state.
  
Below are commands used
```
terraform validate
terraform plan -out=dev.tfpnan
terraform aply
```

### AKS deployments.

+ Create a  namespace.
```
kubectl create namespace dev
```
+ SVC account for the namespace
```
kubectl create serviceaccount devSVC -n dev
```

