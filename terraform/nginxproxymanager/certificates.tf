resource "nginxproxymanager_certificate_letsencrypt" "haranmarkovichcom_cert" {
  domain_names      = ["ha.ranmarkovich.com"]
  letsencrypt_agree = true
  letsencrypt_email = "ranlearndevops@gmail.com" # must match meta.letsencrypt_email in NPM's DB
  dns_challenge     = false
}

resource "nginxproxymanager_certificate_letsencrypt" "n8nranmarkovichcom_cert" {
  domain_names      = ["n8n.ranmarkovich.com"]
  letsencrypt_agree = true
  letsencrypt_email = "ranlearndevops@gmail.com" # must match meta.letsencrypt_email in NPM's DB
  dns_challenge     = false
}
