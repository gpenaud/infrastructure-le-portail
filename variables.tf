
variable project_id {
  type        = string
  description = "Project ID for le-portail infrastructure"
  # test project
  default     = "b2c4f829-56fe-4c2f-95be-1b7d089cc399"
  # le-portail project
  // default     = "341d39c7-1613-45d9-8b9f-e3c001c46cb0"
}

variable deploy_monitoring_stack {
  description = "Determine wether or not we should deploy the monitoring stack (prometheus & grafana & loki)"
  type        = bool
  default     = "false"
}
