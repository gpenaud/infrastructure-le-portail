#
# cluster variables
# -----------------

variable root_path {
  type        = string
  description = "the path to the root directory"
}

variable environment {
  type        = string
  description = "current environment"
}

variable registry_create {
  type        = bool
  description = "wether or not create a docker registry"
}

variable registry_name {
  type        = string
  description = "the name of the registry to create"
}

variable registry_is_public {
  type        = bool
  description = "define public / private registry status"
  default     = false
}
