# challenge 1

Here I am going to use the AKS to setup the 3-tier architecture. Here each micro-service has its own service created and traffic would be directed to them based on the Ingress rules. Here front end running the React Js code and backend running on Node Js code and database as Azure PostgreSQL.


### AKS Ingress controller Internal Load Balancer 

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

+ Service pricipal with contribuor level access to deploy the resources
+ Storage account to save the state.
  
Below are commands used
```
terraform validate
terraform plan -out=dev.tfpnan
terraform aply
```

### AKS deployments.

+ Created namespace. Generally each environment will have its own namepsace.
```
kubectl create namespace demo
```
+ Create the service account within the namespace
```
kubectl create serviceaccount demo-account -n demo
```
+ Create the Role and assign that to service account using role binding
```
apiVersion: v1
kind: Namespace
metadata:
  name: demo-role
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: demo-role
  namespace: demo
rules:
  - apiGroups: [""]
    resources: ["pods", "services", "configmaps", "secrets", "deployments"]
    verbs: ["get", "list", "watch", "create", "update", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: demo-role-binding
  namespace: demo
subjects:
  - kind: ServiceAccount
    name: demo-account
    namespace: demo
roleRef:
  kind: Role
  name: demo-role
  apiGroup: rbac.authorization.k8s.io
```
+ Create the k8s deployment & service yaml files for the code deploy and access. There would be other objects like configmap, secrets, HPA , I am not considering them here.
+ The below k8s files I created already and placed in their code repo.
```
kubectl apply -f ui-app-deployment.yaml
kubectl apply -f ui-app-service.yaml
kubectl apply -f mw-app-deployment.yaml
kubectl apply -f mw-app-service.yaml
```
+ create the ingress YAML file, I have alredy covered above to install the ingress controller
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
    - http:
        paths:
          - path: /ui
            pathType: Prefix
            backend:
              service:
                name: ui-app-service
                port:
                  number: 80
          - path: /mw
            pathType: Prefix
            backend:
              service:
                name: mw-app-service
                port:
                  number: 3000
  ingressClassName: nginx
status:
  loadBalancer:
    ingress:
      - ip: <<IP address>>
```
+ Database creation in postgresql and insert data to retrive the same by application
```
CREATE DATABASE techc;

\c techc;

CREATE TABLE items (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  description TEXT
);

INSERT INTO items (name, description)
VALUES
  ('Big 1', 'Deloitte'),
  ('Big 2', 'EY'),
  ('Big 3', 'KPMG'),
  ('Big 4', 'PwC');
```

