output "db_pwd" {
  value = module.database.db_pwd
  sensitive = true
}