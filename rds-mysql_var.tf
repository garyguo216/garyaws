#variable file for jump server on EC2
variable "mysql_identifier" {
    description = "Name to be used on RDS mysql instance created"
    type        = string
    default     = ""
}

variable "allocated_storage" {
    description = "storage for RDS"
    type        = string
    default     = ""
}

variable "mysql_username" {
    description = "mysql username"
    type        = string
    default     = ""
}

variable "mysql_password" {
    description = "mysql password"
    type        = string
    default     = ""
}
