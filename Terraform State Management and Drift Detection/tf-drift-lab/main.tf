terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

# TODO 1: Define a local_file resource named "config_a"
#   filename = "${path.module}/files/config_a.txt"
#   content  = "environment=dev\nversion=1.0"

# TODO 2: Define a local_file resource named "config_b"
#   filename = "${path.module}/files/config_b.txt"
#   content  = "environment=staging\nversion=1.0"

# TODO 3: Define a local_file resource named "config_c"
#   filename = "${path.module}/files/config_c.txt"
#   content  = "environment=prod\nversion=1.0"
