locals {
  region = var.region
  azs    = slice(data.aws_availability_zones.available.names, 0, 2)
  name   = "${var.project_name}-${var.environment}"

  public_subnet_suffix = "public"

  public_subnet_names = [
    for idx in range(length(local.azs)) :
    "${local.name}-public-${idx + 1}"
  ]

  ubuntu_ami_id = data.aws_ami.ubuntu.id

  meta_options = {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Owner       = "amaanx86"
  }
}
