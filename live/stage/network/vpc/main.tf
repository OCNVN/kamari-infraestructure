terraform {
  backend "s3" {
    profile = "kamari"
    bucket = "kamari-terraform-state"
    key = "stage/network/vpc/terraform.tfstate"
    region = "us-east-1"

    dynamodb_endpoint = "kamari-terraform-state-locks"
    encrypt = true
  }
}

module "vpc_stage" {
  source = "../../../../modules/network/vpc"
}