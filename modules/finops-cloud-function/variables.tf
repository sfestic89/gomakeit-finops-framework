variable "functions" {
  description = "A map of function configurations."
  type        = map(object({
    project           = string
    function_name     = string
    runtime           = string
    source_directory  = string
    trigger_http      = bool
    region            = string
    # Add any other function-specific configuration attributes as needed
  }))
}