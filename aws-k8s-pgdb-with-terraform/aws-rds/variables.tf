
# AWS account secret key. Please don't put this information into a
# .tfvars file and check it into git :)!
# At the very least, create an environment variable named TF_VAR_access_key
# on your laptop; terraform will pick it up from there automatically

variable "secret_key" {
  type        = "string"
  description = "The AWS secret key"
}

# AWS account access key. Please don't put this information into a
# .tfvars file and check it into git :)!
# At the very least, create an environment variable named TF_VAR_access_key
# on your laptop; terraform will pick it up from there automatically

variable "access_key" {
  type        = "string"
  description = "The AWS access key"
}

#Pass these securely, e.g. via environment variables
variable "db_username" {
  type        = "string"
  description = "The database username"
}

variable "db_password" {
  type        = "string"
  description = "The database password"
}
