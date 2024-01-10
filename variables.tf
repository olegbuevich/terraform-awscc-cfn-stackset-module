variable "create" {
  description = "Controls if resources should be created"
  type        = bool
  default     = true
}

###

variable "stack_set_name" {
  description = "The name to associate with the stack set"
  type        = string
}

variable "stack_set_description" {
  description = "A description of the stack set"
  type        = string
  default     = "Managed by Terraform"
}

### template

variable "template_path" {
  description = "Local path of file containing the template body"
  type        = string
  default     = ""
}

variable "template_body" {
  description = "The structure that contains the template body"
  type        = string
  default     = ""
}

variable "template_url" {
  description = "The URL that point to a template that is located in an Amazon S3 bucket"
  type        = string
  default     = null
}

###

variable "auto_deployment" {
  description = "Describes whether StackSets automatically deploys to AWS Organizations accounts that are added to the target organization or organizational unit (OU)"
  type        = any
  default     = {}
}

variable "capabilities" {
  description = "List of stack set template capabilities"
  type        = list(string)
  default     = []
}

variable "managed_execution" {
  description = "Describes whether StackSets performs non-conflicting operations concurrently and queues conflicting operations"
  type        = any
  default     = {}
}

variable "operation_preferences" {
  description = "The preferences for how AWS CloudFormation performs a stack set operation"
  type        = any
  default     = {}
}

variable "parameters" {
  description = "The input parameters for the stack set template"
  type        = any
  default     = {}
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)
  default     = {}
}
