output "ubuntu_ami" {
  description = "Ubuntu AMI resolved by data source"
  value       = "${data.aws_ami.ubuntu.id} (${data.aws_ami.ubuntu.name})"
}

output "control_plane_instance_id" {
  description = "Control plane instance ID"
  value       = module.control_plane.id
}

output "control_plane_private_ip" {
  description = "Control plane private IP (used for kubeadm --apiserver-advertise-address)"
  value       = module.control_plane.private_ip
}

output "control_plane_ssm" {
  description = "SSM Session Manager command for control plane"
  value       = "aws ssm start-session --target ${module.control_plane.id} --region ${var.region}"
}

output "worker_node_instance_id" {
  description = "Worker node instance ID"
  value       = module.worker_node.id
}

output "worker_node_private_ip" {
  description = "Worker node private IP"
  value       = module.worker_node.private_ip
}

output "worker_node_ssm" {
  description = "SSM Session Manager command for worker node"
  value       = "aws ssm start-session --target ${module.worker_node.id} --region ${var.region}"
}
