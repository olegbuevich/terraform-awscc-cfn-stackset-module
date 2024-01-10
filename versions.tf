terraform {
  required_version = ">= 1.0.7"

  required_providers {
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 0.67"
    }
  }
}
