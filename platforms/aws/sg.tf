/*
All OpenShift Container Platform Hosts
tcp/22 from host running the installer/Ansible

etcd Security Group
tcp/2379 from masters
tcp/2380 from etcd hosts

Master Security Group
tcp/8443 from 0.0.0.0/0
tcp/8053 from all OpenShift Container Platform hosts for new environments installed with 3.2
udp/8053 from all OpenShift Container Platform hosts for new environments installed with 3.2

Node Security Group
tcp/10250 from masters
udp/4789 from nodes

Infrastructure Nodes (ones that can host the OpenShift Container Platform router)
tcp/443 from 0.0.0.0/0
tcp/80 from 0.0.0.0/0
*/

### Master nodes

resource "aws_security_group" "master" {
  name        = "${var.cluster_name}-master"
  description = "SG for ${var.cluster_name} master nodes"

  tags {
    Name = "master"
  }
}

resource "aws_security_group_rule" "master_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.master.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "etcd" {
  type              = "ingress"
  security_group_id = "${aws_security_group.master.id}"

  from_port = 2379
  to_port   = 2380
  protocol  = "tcp"
  self      = true
}

resource "aws_security_group_rule" "master_api" {
  type              = "ingress"
  security_group_id = "${aws_security_group.master.id}"

  from_port   = 8443
  to_port     = 8443
  protocol    = "tcp"
  cidr_blocks = ["${var.trusted_cidr_range}"]
}

resource "aws_security_group_rule" "skydns" {
  type              = "ingress"
  security_group_id = "${aws_security_group.master.id}"

  from_port   = 8053
  to_port     = 8053
  protocol    = "all"
  cidr_blocks = ["${var.trusted_cidr_range}"]
}

### Infra nodes

resource "aws_security_group" "infra" {
  name        = "${var.cluster_name}-infra"
  description = "SG for ${var.cluster_name} infra nodes"

  tags {
    Name = "${var.cluster_name}-infra"
  }
}

resource "aws_security_group_rule" "infra_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.infra.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "infra_https" {
  type              = "ingress"
  security_group_id = "${aws_security_group.infra.id}"

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["${var.trusted_cidr_range}"]
}

resource "aws_security_group_rule" "infra_http" {
  type              = "ingress"
  security_group_id = "${aws_security_group.infra.id}"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["${var.trusted_cidr_range}"]
}

### Default node group

resource "aws_security_group" "node" {
  name        = "${var.cluster_name}-node"
  description = "SG for ${var.cluster_name} all nodes"

  tags {
    Name = "${var.cluster_name}-node"
  }
}

resource "aws_security_group_rule" "node_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.node.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.node.id}"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["${var.trusted_cidr_range}"]
}

resource "aws_security_group_rule" "vxlan" {
  type              = "ingress"
  security_group_id = "${aws_security_group.node.id}"

  from_port = 4789
  to_port   = 4789
  protocol  = "udp"
  self      = true
}

resource "aws_security_group_rule" "kubelet" {
  type              = "ingress"
  security_group_id = "${aws_security_group.node.id}"

  from_port = 10250
  to_port   = 10250
  protocol  = "tcp"
  self      = true
}

resource "aws_security_group_rule" "kubelet_external" {
  type              = "ingress"
  security_group_id = "${aws_security_group.node.id}"

  from_port   = 10250
  to_port     = 10250
  protocol    = "tcp"
  cidr_blocks = ["${var.trusted_cidr_range}"]
}
