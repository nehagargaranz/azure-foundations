variable "environment" {
  type        = string
  description = "(Required) Environment name"
}

variable "management_group_parent_id" {
  type        = string
  default     = null
  description = "The ID of the Parent Management Group; Default of 'null' for top level Management Group"
}

variable "subscription_ids" {
  type        = set(string)
  default     = []
  description = "List of Subscription IDs to associate with this Management Group"
}
