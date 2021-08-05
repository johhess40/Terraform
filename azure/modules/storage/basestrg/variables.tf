variable "stgaccounts" {
  type = map(object({
    accntname = string
    rgname    = string
    location  = string
    tier      = string
    repl_type = string
  }))

}

variable "containers" {
  type = map(object({
    name        = string
    access_type = string
  }))
}