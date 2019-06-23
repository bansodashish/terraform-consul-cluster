//  Setup the core provider information.
provider "aws" {
version = "~> 2.0"
region  = "${var.region}"
 access_key = "my-access-key"
 secret_key = "my-secret key"
}