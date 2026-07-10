resource "aws_route53_zone" "ranmarkovich" {
  name          = "ranmarkovich.com"
  comment       = "Managed by Terraform"
  force_destroy = false
  tags          = {}
  tags_all      = {}
}
