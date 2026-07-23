terraform {
  required_providers {
    nginxproxymanager = {
      source  = "Sander0542/nginxproxymanager"
      version = "~> 1.4.0" # Use the version matching your setup
    }
  }
}

provider "nginxproxymanager" {
  url      = "NPM_URL"
  username = "NPM_ADMIN_USERNAME"
  password = "NPM_ADMIN_PASSWORD"
}
