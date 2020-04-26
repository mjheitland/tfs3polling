#--- root/outputs.tf ---
output "project_name" {
  value = var.project_name
}

#--- storage
output "bucket_id" {
  value       = module.storage.id
}

output "bucket_arn" {
  value       = module.storage.arn
}

output "bucket_name" {
  value       = module.storage.name
}

output "bucket_domain_name" {
  value       = module.storage.bucket_domain_name
}

output "bucket_regional_domain_name" {
  value       = module.storage.bucket_regional_domain_name
}


#--- networking
#output "vpc1_id" {
#  value = module.networking.vpc1_id
#}
#output "subprv1_id" {
#  value = module.networking.subprv1_id
#}
#output "sgprv1_id" {
#  value = module.networking.sgprv1_id
#}

#--- compute
#output "keypair_id" {
#  value = module.compute.keypair_id
#}
#output "provider_ids" {
#  value = module.compute.provider_ids
#}
#output "consumer_ids" {
#  value = module.compute.consumer_ids
#}
