locals {
  service_principals_output = {
    for sp in var.service_principals : sp.name_suffix => {
      display_name   = azuread_service_principal.module[sp.name_suffix].display_name
      application_id = azuread_service_principal.module[sp.name_suffix].application_id
      object_id      = azuread_service_principal.module[sp.name_suffix].object_id
      secret         = azuread_application_password.module[sp.name_suffix].value
      secret_key_id  = azuread_application_password.module[sp.name_suffix].id
    }
  }
}

output "service_principals" {
  value       = local.service_principals_output
  sensitive   = true
  description = "Service Principal details; display_name, application_id, object_id, secret, secret_key_id"
}
