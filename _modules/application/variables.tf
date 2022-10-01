#
# global variables
# ----------------

variable root_path {
  type        = string
  description = "the path to the root directory"
}

variable force_helm_upgrade {
  type        = bool
  description = "wether or not force helm release to be upgraded"
}

variable environment_values_file {
  type        = string
  description = "the values file for alterconso with environment-related variable"
}
