provider "aws" {}

module "apache" {
  source        = "./modules/apache"
}

module "haproxy" {
  source         = "./modules/haproxy"
}

module "control" {
  apache_address  = module.apache.apache_ip
  haproxy_address = module.haproxy.haproxy_ip
  source          = "./modules/control"
}


