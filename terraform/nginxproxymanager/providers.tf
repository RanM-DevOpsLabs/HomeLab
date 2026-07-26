terraform {
  required_providers {
    nginxproxymanager = {
      source  = "Sander0542/nginxproxymanager"
      version = "~> 1.4.0" # Use the version matching your setup
    }
  }
}

provider "nginxproxymanager" {
  url      = "http://192.168.1.220:81"
  username = "ranlearndevops@gmail.com"
  password = "rMpQWP2G3trQHyA"
}
