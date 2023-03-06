#variable file for jump server on EC2

variable "ec2_name_appserver" {
    description = "Name to be used on jumpserer instance created"
    type        = string
    default     = ""
}

variable "ec2_key_name_appserver" {
    description = "key name for jumpserver instance"
    type        = string
    default     = ""
}

variable "deletion_protection_appserver" {
    description = "If true, enables EC2 Instance Termination Protection"
    type        = bool
    default     = true
}

variable "delete_volumes_on_termination_appserver" {
    description = "If true, volumes will be deleted upon EC2 instance termination"
    type        = bool
    default     = true
}

variable "ebs_block_device_appserver" {
    description = "Additional EBS block devices to attach to the instance"
    type        = list(map(string))
    default     = []
}

variable "iam_instance_profile_appserver" {
    description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
    type        = string
    default     = ""
}

variable "ec2_type_appserver" {
    description = "The type of instance to start"
    type        = string
}

variable "root_block_device_volume_size_appserver" {
    description = "EBS volume size"
    type = number
    default = 50 
}

variable "root_block_device_volume_type_appserver" {
    description = "Volume type"
    type = string
    default = "gp3"
}

variable "sg_ip_address_range_appserver" {
    description = "whilelist for security group IP range"
    type = list(string)
    default = ["0.0.0.0/0"]
}

variable "sg_ports_range_appserver" {
    description = "the port for sg"
    type = list(string)
    default = null
}