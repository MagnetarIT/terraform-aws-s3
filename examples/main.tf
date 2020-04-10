provider "aws" {
  region = "eu-west-2"
}

resource "random_id" "s3" {
  byte_length = 4
}

module "s3" {
  source      = "../"
  namespace   = "mag"
  environment = "test"
  name        = "app"
  attributes  = [random_id.s3.hex]
}