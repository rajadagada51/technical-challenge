variable "resource_group_name" {}

variable "location" {}

variable "product_name" {
  default = "tc"
}

variable "pg_sku_name" {
  default = "B_Gen4_2"
}

variable "pg_version" {
  default = 11
}

variable "pg_username" {} 
