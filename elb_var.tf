#define variable for elb
variable "load_balancer_name" {
    description = "The name of the load balancer"
    type        = string
    default     = ""
}

variable "internal_load_balancer" {
    description = "Is the load balancer internal?"
    type        = bool
    default     = false
}

variable "load_balancer_type" {
    description = "The type of load balancer"
    type        = string
    default     = "application"
}

variable "enable_deletion_protection" {
    description = "Should deletion protection be enabled?"
    type        = bool
    default     = false
}

variable "enable_access_logs" {
   description = "Should access logs be enabled?"
    type        = bool
    default     = false
}

variable "enable_cross_zone_load_balancing" {
    description = "Should cross-zone load balancing be enabled?"
    type        = bool
    default     = true
}