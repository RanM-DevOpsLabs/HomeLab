resource "nginxproxymanager_proxy_host" "haranmarkovichcom" {
        advanced_config         = ""
        allow_websocket_upgrade = true
        block_exploits          = true
        caching_enabled         = false
        certificate_id          = nginxproxymanager_certificate_letsencrypt.haranmarkovichcom_cert.id
        domain_names            = [
            "ha.ranmarkovich.com",
        ]
        enabled                 = true
        forward_host            = "192.168.122.1"
        forward_port            = 8123
        forward_scheme          = "http"
        hsts_enabled            = false
        hsts_subdomains         = false
        http2_support           = false
        locations               = []
        ssl_forced              = true
    }

resource "nginxproxymanager_proxy_host" "n8nranmarkovichcom" {
  access_list_id          = null
  advanced_config         = null
  allow_websocket_upgrade = true
  block_exploits          = true
  caching_enabled         = false
  certificate_id          = nginxproxymanager_certificate_letsencrypt.n8nranmarkovichcom_cert.id
  domain_names            = ["n8n.ranmarkovich.com"]
  enabled                 = true
  forward_host            = "192.168.122.1"
  forward_port            = 5678
  forward_scheme          = "http"
  hsts_enabled            = false
  hsts_subdomains         = false
  http2_support           = false
  locations = [
  ]
  ssl_forced = true
}
