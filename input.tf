variable "key" {
  type    = string
  default = "maya"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_user" {
  type = string
  default = "ubuntu"
}

variable "instance_type" {
  type = list(string)
  default = [ "t3.micro", "t3.small", "m7i-flex.large", "c7i-flex.large" ]
}