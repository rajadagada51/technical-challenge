variable "resource_group_name" {}

variable log_analytics_workspace_name {
    default = "challengeLogAnalyticsWorkspaceName"
}

variable log_analytics_workspace_location {
    default = "eastus"
}

variable log_analytics_workspace_sku {
    default = "PerGB2018"
}
