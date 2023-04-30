variable "cluster_client_id" {}

variable "cluster_client_secret" {}

variable "client_id" {}

variable "client_secret" {}

variable "node_count" {
  description = "number of nodes to be in node pool"
  default     = 2
}

variable "dns_prefix" {
  description = "DNS Suffix"
  default     = "technicalchallenge"
}

variable cluster_name {
  description = "AKS cluster name"
  default     = "technicalchallenge"
}

variable resource_group_name {
  description = "AKS cluster resource group"
  default     = "technicalchallenge"
}

variable location {
  description = "region"
  default     = "eastus"
}

variable log_analytics_workspace_name {
  default = "tcLogAnalyticsWorkspaceName"
}
variable log_analytics_workspace_location {
  default = "eastus"
}
variable log_analytics_workspace_sku {
  default = "PerGB2018"
}

variable "os_disk_size_gb" {
  default     = 512
}

variable subnet_name {
  description = "subnet where node be placed"
  default     = "tc-subnet"
}

variable vnet_name {
  description = "VNET for the AKS"
  default     = "tc-vnet"
}

variable subnet_cidr {
  description = "subnet CIDR range"
  default     = "10.194.139.128/26"
}

variable kubernetes_version {
  description = "version of the kubernetes cluster"
  default     = "1.24.10"
}

variable "vm_size" {
  description = "size/type of VM to use for nodes"
  default     = "Standard_D1_v2"
}

variable "address_space" {
  description = "CIDR range for VNET"
  default     = "10.194.139.0/24"
}
variable "min_count" {
  default     = 1
  description = "Min NodeCount"
}
variable "max_count" {
  default     = 2
  description = "Max Node Count"
}

variable "ssh_public_key" {
   default = "~/.ssh/id_rsa.pub"
 }
