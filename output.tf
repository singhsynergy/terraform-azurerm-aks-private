output "jumpbox_vm_ip" {
  description = "Jumpbox VM IP"
  value       = azurerm_linux_virtual_machine.jumpbox.public_ip_address
}

output "jumpbox_vm_username" {
  description = "Jumpbox VM username"
  value       = var.vm_user
}

output "jumpbox_vm_user_password" {
  description = "Jumpbox VM username"
  value       = var.vm_password
}

