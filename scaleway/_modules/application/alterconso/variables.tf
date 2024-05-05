#
# global variables
# ----------------

variable root_path {
  type        = string
  description = "the path to the root directory"
}

variable environment {
  type        = string
  description = "current environment"
}

variable force_helm_upgrade {
  type        = bool
  description = "wether or not force helm release to be upgraded"
}
