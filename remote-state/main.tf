variable "aws_region" { default = "" }
variable "remote_state_s3_bucket" { default = "" }

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.remote_state_s3_bucket

  versioning {
    enabled = true
  }

  #lifecycle {
  #prevent_destroy = true
  #}
}
