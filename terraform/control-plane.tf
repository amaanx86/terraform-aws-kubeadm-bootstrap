module "control_plane" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  name = "${local.name}-control-plane"

  ami           = local.ubuntu_ami_id
  instance_type = var.control_plane_instance_type

  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  metadata_options = local.meta_options

  root_block_device = {
    size      = 50
    type      = "gp3"
    encrypted = true
  }

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for kubeadm control plane"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  security_group_vpc_id = module.vpc.vpc_id

  security_group_ingress_rules = {
    k8s_api = {
      description = "Kubernetes API server"
      from_port   = 6443
      to_port     = 6443
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
    etcd = {
      description = "etcd client and peer"
      from_port   = 2379
      to_port     = 2380
      ip_protocol = "tcp"
      cidr_ipv4   = var.cidr
    }
    kubelet = {
      description = "kubelet API"
      from_port   = 10250
      to_port     = 10250
      ip_protocol = "tcp"
      cidr_ipv4   = var.cidr
    }
    kube_scheduler = {
      description = "kube-scheduler"
      from_port   = 10259
      to_port     = 10259
      ip_protocol = "tcp"
      cidr_ipv4   = var.cidr
    }
    kube_controller = {
      description = "kube-controller-manager"
      from_port   = 10257
      to_port     = 10257
      ip_protocol = "tcp"
      cidr_ipv4   = var.cidr
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
