output "jumpbox_vm_ip" {
  description = "Jumpbox VM public IP"
  value       = module.jumpbox.jumpbox_vm_ip
}

output "jumpbox_vm_username" {
  description = "Jumpbox VM username"
  value       = module.jumpbox.jumpbox_vm_username
}

output "jumpbox_vm_user_password" {
  description = "Jumpbox VM password (sensitive)"
  value       = module.jumpbox.jumpbox_vm_user_password
  sensitive   = true
}
