variable "my_network" {
    type = string
}

variable "image" {
    type = string
    default = "postgres:14"
}

variable "PG_USER" {
    type = string
    default = "user"
}

variable "PG_PWD" {
    type = string
    default = "pass"
}

variable "PG_DB_NAME" {
    type = string
    default = "feedback"
}