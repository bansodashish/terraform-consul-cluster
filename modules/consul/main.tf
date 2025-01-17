# AWS Keypair for SSH
resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEArkk8DM5RfV7XKXan7s99X0BiipydcDtntTSTBpBf1yiRSOSuBfbzwdWIehJjo9IEgCHHSnRsdwGWuk04aFeJ4JTwer2SoUAhPS26knxTePatDuAoNBkdA8AlDA5eALjwbh6j/J65jHCMT9C/w2ZS/St989xgURHqYXRStqNASQ0fXzso0BJVKjGSVYh3z3ZE1aDFEwIozOLZaPxgNrQgN/WZ5+U5RzDaPg/zsbtqR22CZCXJ28fZxl4KY8OR2ZNL3ZFx075fo7hoakwkexivmXdlH7HP1I2oDsa+692PL1hYQeiI/QHG1kyp3eDIToQMD937IouXu2farG+IaAWC/Q== rsa-key-20190616"
}

// AMIs by region for AWS Optimised Linux
data "aws_ami" "amazonlinux" {
  most_recent = true

  owners = ["137112412989"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }
  }  
  
  data "template_file" "consul" {
  template = "${file("${path.module}/files/consul-node.sh")}"

 vars = {
    asgname = "${var.asgname}"
    region  = "${var.region}"
    size    = "${var.min_size}"
  }
}
//  Launch configuration for the consul cluster auto-scaling group.
resource "aws_launch_configuration" "consul-cluster-lc" {
  name_prefix          = "consul-node-"
  image_id             = "${data.aws_ami.amazonlinux.image_id}"
  instance_type        = "${var.amisize}"
  user_data            = "${data.template_file.consul.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.consul-instance-profile.id}"

   security_groups = [
    "${aws_security_group.consul-cluster-vpc.id}",
    "${aws_security_group.consul-cluster-public-web.id}",
    "${aws_security_group.consul-cluster-public-ssh.id}",
  ]
lifecycle {
    create_before_destroy = true
  }

  key_name = "${var.key_name}"
}
//  Load balancers for our consul cluster.
resource "aws_elb" "consul-lb" {
  name = "consul-lb"

  security_groups = [
    "${aws_security_group.consul-cluster-vpc.id}",
    "${aws_security_group.consul-cluster-public-web.id}",
  ]

  subnets = ["${aws_subnet.public-a.id}", "${aws_subnet.public-b.id}","${aws_subnet.public-c.id}"]

  listener {
    instance_port     = 8500
    instance_protocol = "http"
    lb_port           = 8500
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8500/ui/"
    interval            = 30
  }
}
//  Auto-scaling group for our cluster.
resource "aws_autoscaling_group" "consul-cluster-asg" {
  depends_on           = ["aws_launch_configuration.consul-cluster-lc"]
  name                 = "${var.asgname}"
  launch_configuration = "${aws_launch_configuration.consul-cluster-lc.name}"
  min_size             = "${var.min_size}"
  max_size             = "${var.max_size}"
  vpc_zone_identifier  = ["${aws_subnet.public-a.id}", "${aws_subnet.public-b.id}","${aws_subnet.public-c.id}"]
  load_balancers       = ["${aws_elb.consul-lb.name}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "Consul Node"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "consul-cluster"
    propagate_at_launch = true
  }
}
