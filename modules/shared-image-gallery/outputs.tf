output "shared_image_gallery_id" {
  value       = azurerm_shared_image_gallery.module.id
  description = "The ID of the Shared Image Gallery"
}

output "shared_image_gallery_name" {
  value       = azurerm_shared_image_gallery.module.unique_name
  description = "The unique name of the Shared Image Gallery"
}
