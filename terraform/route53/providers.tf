terraform {
  required_version = ">= 1.5.0" # Required if using modern import blocks
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1" # Replace with your target AWS region
  profile = "ran_iam_user_admin_681048796370"   # Optional: Replace with your local ~/.aws/credentials profile
}

