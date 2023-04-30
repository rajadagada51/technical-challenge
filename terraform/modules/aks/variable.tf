variable "dns_prefix" {}
  
variable "location" {}

variable "cluster_name" {}

variable "resource_group_name" {}

variable "kubernetes_version" {}

variable "os_disk_size_gb" {}

variable "client_id" {}

variable "client_secret" {}

variable "min_count" {}

variable "max_count" {}

variable "node_count" {}

variable "vm_size" {}

variable "vnet_subnet_id" {}

variable "api_server_authorized_ip_ranges" {
  default     = "0.0.0.0/0"
}

variable "dns_service_ip" {
  default     = "172.20.0.10"
}

variable "network_plugin" {
  default     = "azure"
}

variable "service_cidr" {
  default     = "172.20.0.0/16"
}

variable "ssh_public_key" {
  default  = "~/.ssh/id_rsa.pub"
}

variable "max_pods" {
  default = "15"
}

variable "agent_pool_name" {
  default     = "default"
}

variable "default_pool_type" {
  default     = "VirtualMachineScaleSets"
}

variable "agent_pool_type" {
  default     = "VirtualMachineScaleSets"
}

variable "default_pool_name" {
  default     = "default"
}
