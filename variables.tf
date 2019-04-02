variable "rg" {
    default = "rgtemplate"
}

variable "vmname" {
    default = "kubevm"
}

variable "region" {
    default = "eastus"
}

variable "tags" {
    type = "map"
    default = {
        environment = "test"
        source      = "CloudArchGroup"
    }
}