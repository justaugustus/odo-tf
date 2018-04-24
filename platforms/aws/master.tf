resource "aws_instance" "master" {
  count = "${var.master_count}"

  ami                    = "${data.aws_ami.rhel.id}"
  instance_type          = "${var.master_instance_type}"
  key_name               = "${var.aws_key_name}"
  subnet_id              = "${aws_subnet.subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.node.id}", "${aws_security_group.master.id}", "${aws_security_group.infra.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.master.id}"

  root_block_device {
    volume_type = "${var.master_root_volume_type}"
    volume_size = "${var.master_root_volume_size}"
    iops        = "${var.master_root_volume_type == "io1" ? var.master_root_volume_iops : 0}"
  }

  # TODO: Add additional block devices
  # TODO: Fix tags
  tags {
    Name = "HelloWorld"
  }
}

resource "aws_iam_instance_profile" "master" {
  name = "${var.cluster_name}-master-profile"
  role = "${aws_iam_role.master.name}"
}

resource "aws_iam_role" "master" {
  name = "${var.cluster_name}-master-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "ec2:DetachVolume",
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "elasticloadbalancing:CreateLoadBalancer",
                "ec2:DescribeInstances",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:ConfigureHealthCheck",
                "ec2:CreateTags",
                "elasticloadbalancing:CreateLoadBalancerListeners",
                "ec2:DescribeSecurityGroups",
                "ec2:CreateVolume",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "ec2:RevokeSecurityGroupIngress",
                "elasticloadbalancing:DescribeLoadBalancers",
                "ec2:DeleteVolume",
                "ec2:CreateSecurityGroup",
                "elasticloadbalancing:DeleteLoadBalancerListeners",
                "ec2:DescribeSubnets",
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "ec2:DescribeRouteTables"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
