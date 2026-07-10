import {
  to = aws_route53_record.cname_0ab5995d_ranmarkovichcom
  # Format: ZoneID_RecordName_Type_
  id = "Z02421471ZDTEE1DXEG1G__4a296fde354d2e5081589f4b0ab5995d.www.ranmarkovich.com_CNAME_"
}

moved {
  from = aws_route53_record.ed05defd_ranmarkovichcomcname
  to   = aws_route53_record.cname_ed05defd_ranmarkovichcom
}


resource "aws_route53_record" "ranmarkovichcoma" {
  name                             = "ranmarkovich.com"
  type                             = "A"
  zone_id                          = "Z02421471ZDTEE1DXEG1G"
  alias {
    evaluate_target_health = false
    name                   = "dl1bf0ctb9aun.cloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2"
  }
}

resource "aws_route53_record" "ranmarkovichcomaaaa" {
  name                             = "ranmarkovich.com"
  type                             = "AAAA"
  zone_id                          = "Z02421471ZDTEE1DXEG1G"
  alias {
    evaluate_target_health = false
    name                   = "dl1bf0ctb9aun.cloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2"
  }
}

resource "aws_route53_record" "ranmarkovichcomns" {
  name                             = "ranmarkovich.com"
  type                             = "NS"
  records                          = ["ns-1411.awsdns-48.org.", "ns-1717.awsdns-22.co.uk.", "ns-489.awsdns-61.com.", "ns-880.awsdns-46.net."]
  zone_id                          = "Z02421471ZDTEE1DXEG1G"
  ttl                              = 172800
}

# __generated__ by Terraform
resource "aws_route53_record" "haranmarkovichcoma" {
  name                             = "ha.ranmarkovich.com"
  records                          = ["176.228.84.54"]
  ttl                              = 300
  type                             = "A"
  zone_id                          = "Z02421471ZDTEE1DXEG1G"
}

# __generated__ by Terraform
resource "aws_route53_record" "ranmarkovichcomsoa" {
  name                             = "ranmarkovich.com"
  records                          = ["ns-1411.awsdns-48.org. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
  set_identifier                   = null
  ttl                              = 900
  type                             = "SOA"
  zone_id                          = "Z02421471ZDTEE1DXEG1G"
}

# __generated__ by Terraform
resource "aws_route53_record" "waharanmarkovichcoma" {
  name                             = "waha.ranmarkovich.com"
  records                          = ["176.228.25.69"]
  ttl                              = 300
  type                             = "A"
  zone_id                          = "Z02421471ZDTEE1DXEG1G"
}

# __generated__ by Terraform
resource "aws_route53_record" "cname_ed05defd_ranmarkovichcom" {
  name                             = "_1fcc35c992e0fd93689830f3ed05defd.ranmarkovich.com"
  records                          = ["_715ec5f11e19a2039031b1cc21bc7b06.xlfgrmvvlj.acm-validations.aws."]
  ttl                              = 300
  type                             = "CNAME"
  zone_id                          = "Z02421471ZDTEE1DXEG1G"
}

# __generated__ by Terraform
resource "aws_route53_record" "n8nranmarkovichcoma" {
  name                             = "n8n.ranmarkovich.com"
  records                          = ["176.228.84.54"]
  ttl                              = 300
  type                             = "A"
  zone_id                          = "Z02421471ZDTEE1DXEG1G"
}

# __generated__ by Terraform
resource "aws_route53_record" "cname_0ab5995d_ranmarkovichcom" {
  name                             = "_4a296fde354d2e5081589f4b0ab5995d.www.ranmarkovich.com"
  records                          = ["_504e350d9e0d6bb1f27b4ea61d009891.xlfgrmvvlj.acm-validations.aws."]
  ttl                              = 300
  type                             = "CNAME"
  zone_id                          = "Z02421471ZDTEE1DXEG1G"
}
