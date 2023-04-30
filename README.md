# technical-challenge - 1

There are multiple approaches to design the infsrastructure for the 3-tier application components. 
Here I would like to present 2 approaches mainly using Azure PaaS services, we can also use IaaS(VM). As most of the applications are now moving towards microservice driven approach, so PaaS services like container orchestration AKS, App services would give  better results in terms of speed of deployment, execution and isolation.

These 2 solutions I heavily deployed for most of the products.

Here I am assuming the application is being hosted on single region, so I am not going to use either Traffic Manager or Front Door.

#### Technology Stack
```
Front End     : ReactJS
Middleware    : NodeJs
Database      : Azure PostgreSQL
```

I have created sample ReactJS and NodeJs code in the given repositories and also I have updated Dockerfile and K8s spec files to deploy them onto the Kuberenetes namespace. Also I have covered the terraform modules in this same branch.
```
https://github.com/rajadagada51/sample-react-app.git
https://github.com/rajadagada51/sample-node-app.git
```

### Solution 1: Using AKS. Given detailed steps about AKS, NSG rules, UDR, Network Plugin, Ingress Controller, Firewall rules and RBAC. These are very importent to setup the AKS cluster

![image](https://user-images.githubusercontent.com/97170585/235369860-534b6e6c-6caf-4e79-af41-04e6ebf746a3.png)


### Prerequisites

The below are required before provisioning the AKS 

```
Resource Group                          : To place a AKS in existing RG or new.
Deployment Service Principal (RG level) : SPN should have contributor level access at Resource Group level to deploy the AKS resources.
AKS Service Principal                   : SPN used by AKS to provision resources like dynamic disks, load balancers.
VNET/Subnet                             : An existing or new VNET with a subnet.
```

##### As part of the Governance, we do create and maintain the VNET/SUBNET( Address space planning) separately as per the project requirements. After that, we do provision the application specific Azure resources integrating VNET/SUBNET. If the subscription is being used by multiple independent applications, there is huge control on the RG level as well.

AKS service principal should have the following the RBAC

```
  Contributor                 : To Resource group where AKS will be deployed
  Read Access to Managed UDR  : Organisations will maintain the predefined UDR to control the egress traffic. The predefined routes must be read and must replicate them to the Route Table associated with the AKS subnet.
  Network Contributor         : To subnet where AKS nodes resides
```

### Network type (plugin) Kubenet vs Azure CNI (Choosing KUBENET)

+ Kubenet saves IP address space. As pods get IP addresses from the internal Kubernetes subnet.
+ Kubenet uses Kubernetes internal or external load balancer to reach pods from outside of the cluster.

Azure CNI
+ In this approach, pods get IP addresses from the AKS subnet. There is huge possibility of IP exhaust if not planned very well.
+ We cannot upgrade or scale AKS cluster if no IP address left from the subnet.

### AKS Ingress controller Internal Load Balancer (No External Load Balancer)

+ We do not create the ingress controller external load balancer. Instead we create the internal load balance and the Load Balancer gets the private IP address from the AKS subnet. Then we would request the Network/perimeter team to create the Public IP and NAT to the Internal Load Balancer private IP.
+ Deploy the Ingress controller in each namespace

Advantages:
+ SSL offloading
+ Ability to map to multiple services. 

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

helm install ingress-nginx  ingress-nginx/ingress-nginx \
  --set controller.replicaCount=2 \ 
  --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \ 
  --set defaultBackend.nodeSelector."beta\.kubernetes\.io\/os"=linux \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal"="true"
```

### AKS properties

The below are the values/CIDR ranges I would pass while creating the AKS cluster either through terraform or cli or manually.

```
Kubernetes versions : 1.24.10
Node pools : 1 node pool
Enable RBAC : Local accounts with Kubernetes RBAC
HTTP Application Routing : No
Network type (plugin) : kubenet
Authentication method : Service principal
Monitoring : Yes
Pod CIDR : 192.168.0.0/16
Service CIDR : 172.20.0.0/16
DNS service IP : 172.20.0.10
Docker bridge CIDR : 172.17.0.1/16
```

### AKS Subnet NSG rules

The below are NSG rules are must be implemented to control the Inbound and Outbound traffic.

```
Inbound Rules
  
name                         = "AKS_INTERNAL_INBOUND"
priority                     = 210
direction                    = "inbound"
access                       = "Allow"
protocol                     = "*"
source_port_range            = "*"
destination_port_range       = "*"
source_address_prefixes      = ["192.168.0.0/16", "172.20.0.0/16", "<AKS_CLUSTER_SUBNET>"]
destination_address_prefixes = ["192.168.0.0/16", "172.20.0.0/16", "<AKS_CLUSTER_SUBNET>"]

 name                        = "AKS_INTERNET_INBOUND"
 priority                    = 220
 direction                   = "inbound"
 access                      = "Allow"
 protocol                    = "*"
 source_port_range           = "*"
 destination_port_ranges     = ["9000", "10250"]
 source_address_prefix       = "Internet"
 destination_address_prefix  = "*"

Outbound Rules

 name                        = "AKS_INTERNET_OUTBOUND"
 priority                    = 160
 direction                   = "outbound"
 access                      = "Allow"
 protocol                    = "*"
 source_port_range           = "*"
 destination_port_ranges     = ["80", "443", "22", "53", "9000", "10250"]
 source_address_prefix       = "<AKS_CLUSTER_SUBNET>"
 destination_address_prefix  = "Internet"

```

### Post Deployment 

##### Firewall Rules

Post AKS cluster creation, we need to create a rule for  AKS source subnet to access the AKS API server
```
Create Web filtering rules to allow the subnet to the API Server

Source IP   : "Aks Cluster subnet ip range"
Destination : FQDN of the AKS Cluster
Ports       : 443(TCP), 123(UDP), 1194(UDP), 53(UDP), 9000(TCP)
```

#### RBAC

Create Admin Group in Azure AD and grant the following access.

Apply the following RBAC Rules. 

```
AKS Cluster Object
AZURE KUBERNETES SERVICE CLUSTER ADMIN ROLE
AZURE KUBERNETES SERVICE CLUSTER USER ROLE 
Contributor 
Reader

MC Resource Group
Contributor

SubNet
Network Contributor
```

#### UDR

Organisation generally defines a list of predefined UDRs upon requests for VNETs/Subnets, but AKS provisions its own. Its is very important to replicate organisation defined routes to the newly created AKS route table. It is to ensure egress traffic going through the predefined firewall deployed within a given subscription or region. 


### AKS SETUP - Using Terraform

We are using the Terraform Enterprise(Self-hosted) to maintain the private registry modules, State and Sentinal policies. For this demo purpose, I have followed the below approach.

+ Service pricipal with contribuor level access to deploy the resources
+ Storage account to save/maintain the state.
+ I have created the terraform using modular approach.
+ I have not used '.tfvars' concept here, due to lack of time.
Below are commands used
```
terraform validate
terraform init -backend-config="<path>/backend.tfvsrs"
terraform plan -out=dev.tfpnan
terraform aply -out=dev.tfplan
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

## Solution 2: Using Azyre App Servics. Given detailed design daigram about traffic flow and information abut PaaS components.

![image](https://user-images.githubusercontent.com/97170585/235370142-9f23c93b-8b08-4651-ad8f-2cb8cfb1de0c.png)

```
Azure PaaS Services:
-------------------
Azure Application Gateway
Static Web Apps
API Management services
App Services
Azure Database for PostgreSQL flexible servers
KeyVault
Storage
Azure Redis
```
