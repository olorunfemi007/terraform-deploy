variable "ami" {
  type    = string
  default = "ami-0d77c9d87c7e619f9"

}

variable "instance_type" {
  type = list(string)
  default = ["t2.micro", "t2.small", "t2.medium", "t2.large"]
}