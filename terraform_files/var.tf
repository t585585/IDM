# variables

variable "core_fraction" {
  type = string
  # 5, 20, 100
  default = "5"
}

variable "disk_type" {
  type = string
  # network-hdd , network-nvme
  default = "network-hdd"
}

variable "preemptible" {
  type = string
  #true , false
  default = "true"
}

#TF_VAR_
variable "YC_TOKEN" {
  description = "Yandex Cloud token"
  type        = string
}

variable "CLOUD_ID" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "FOLDER_ID" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

# variable "META" {
#   description = "User data for instances"
#   type        = string
# }

variable "GITHUB_WORKSPACE" {
  description = "GitHub workspace path"
  type        = string
}