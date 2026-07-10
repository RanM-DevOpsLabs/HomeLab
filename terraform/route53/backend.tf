terraform {
  required_version = ">= 1.9.8"

  backend "s3" {
    region         = "ap-northeast-1"
    bucket         = "681048796370-remote-state-bucket"
    key            = "repos/RanM-DevOpsLabs/HomeLab/terraform/route53/terraform.tfstate"
    encrypt        = true
  }
}
