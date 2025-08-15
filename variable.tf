variable "sg_name" {
    type = string
    default = "web"
}

variable "sg_description" {
    type = string
    default = "allow_all"
}

variable "inbound_from_port" {
    # type = 0
    default = 0
}

variable "cidr_blocks" {
    type = list
    default = ["0.0.0.0/0"]

}