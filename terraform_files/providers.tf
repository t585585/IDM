terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.75.0"
    }
  }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "t585585-idm-tf-bucket"
    region     = "ru-central1-a"
    key        = "idm/terraform.tfstate"
    access_key = "" 
    secret_key = "" 

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token     = var.YC_TOKEN
  cloud_id  = var.CLOUD_ID
  folder_id = var.FOLDER_ID
}