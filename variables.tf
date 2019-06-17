//  The region we will deploy our cluster into.
variable "region" {
  description = "Region to deploy the Consul Cluster into"
  //  The default below will be fine for many, but to make it clear for first
  //  time users, there's no default, so you will be prompted for a region.
  //  default = "us-east-1"
}

//  The public key to use for SSH access.
variable "public_key_path" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEArkk8DM5RfV7XKXan7s99X0BiipydcDtntTSTBpBf1yiRSOSuBfbzwdWIehJjo9IEgCHHSnRsdwGWuk04aFeJ4JTwer2SoUAhPS26knxTePatDuAoNBkdA8AlDA5eALjwbh6j/J65jHCMT9C/w2ZS/St989xgURHqYXRStqNASQ0fXzso0BJVKjGSVYh3z3ZE1aDFEwIozOLZaPxgNrQgN/WZ5+U5RzDaPg/zsbtqR22CZCXJ28fZxl4KY8OR2ZNL3ZFx075fo7hoakwkexivmXdlH7HP1I2oDsa+692PL1hYQeiI/QHG1kyp3eDIToQMD937IouXu2farG+IaAWC/Q== rsa-key-20190616"
}

//  This map defines which AZ to put 'Public Subnet A' in, based on the
//  region defined. You will typically not need to change this unless
//  you are running in a new region!
variable "subnetaz1" {
  type = "map"

  default = {
    us-east-1 = "us-east-1a"
    us-east-2 = "us-east-2a"
    us-east-3 = "us-east-3a"
    us-west-1 = "us-west-1a"
    us-west-2 = "us-west-2a"
    us-west-3 = "us-west-3a"
    eu-west-1 = "eu-west-1a"
    eu-west-2 = "eu-west-2a"
    eu-west-3 = "eu-west-3a"
    eu-central-1 = "eu-central-1a"
    ap-southeast-1 = "ap-southeast-1a"
        }
}

variable "subnetaz2" {
  type = "map"

  default = {
    us-east-1 = "us-east-1b"
    us-east-2 = "us-east-2b"
    us-east-3 = "us-east-3b"
    us-west-1 = "us-west-1b"
    us-west-2 = "us-west-2b"
    us-west-3 = "us-west-3b"
    eu-west-1 = "eu-west-1b"
    eu-west-2 = "eu-west-2b"
    eu-west-3 = "eu-west-3b"
    eu-central-1 = "eu-central-1b"
    ap-southeast-1 = "ap-southeast-1b"
  }
}
variable "subnetaz3" {
  type = "map"

  default = {
    us-east-1 = "us-east-1c"
    us-east-2 = "us-east-2c"
    us-east-3 = "us-east-3c"
    us-west-1 = "us-west-1c"
    us-west-2 = "us-west-2c"
    us-west-3 = "us-west-3c"
    eu-west-1 = "eu-west-1c"
    eu-west-2 = "eu-west-2c"
    eu-west-3 = "eu-west-3c"
    eu-central-1 = "eu-central-1c"
    ap-southeast-1 = "ap-southeast-1b"
        }
}
