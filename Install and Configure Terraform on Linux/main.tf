# main.tf
# This block tells Terraform which provider to use
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"  # official local provider
      version = "~> 2.5"           # provider version constraint
    }
  }
}

# This block configures the local provider (no settings needed)
provider "local" {}

# This resource creates a simple text file on disk
resource "local_file" "my_first_file" {
  filename = "${path.module}/hello.txt"   # file path (in the same folder)
  content  = "Hello from Terraform! This file was created by IaC.\n"  # file content
}
