variable "node_names" {
  description = "List of Kubernetes node names to check for readiness"
  type        = list(string)
}

variable "control_plane_ip" {
  description = "IP address of the control plane node to query"
  type        = string
}

variable "timeout_seconds" {
  description = "Timeout in seconds for node readiness check"
  type        = number
  default     = 600
}

variable "check_interval" {
  description = "Interval in seconds between readiness checks"
  type        = number
  default     = 10
}
