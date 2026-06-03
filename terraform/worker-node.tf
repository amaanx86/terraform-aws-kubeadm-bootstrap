module "worker_node" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  name = "${local.name}-worker-1"

  ami           = local.ubuntu_ami_id
  instance_type = var.worker_instance_type

  subnet_id                   = module.vpc.public_subnets[1]
  associate_public_ip_address = true

  metadata_options = local.meta_options

  root_block_device = {
    size      = 50
    type      = "gp3"
    encrypted = true
  }

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for kubeadm worker node"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  security_group_vpc_id = module.vpc.vpc_id

  security_group_ingress_rules = {
    kubelet = {
      description = "kubelet API"
      from_port   = 10250
      to_port     = 10250
      ip_protocol = "tcp"
      cidr_ipv4   = var.cidr
    }
    nodeport = {
      description = "NodePort services"
      from_port   = 30000
      to_port     = 32767
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  security_group_egress_rules = {
    all = {
      description = "Allow all outbound traffic"
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = local.tags
}
