variable "prefix" {
  description = "Prefix to give to AWS resources"
}

variable "slack_api_token" {
  description = "Slack API token"
}

variable "slack_channel" {
  description = "Slack channel name to emit messages into"
}

variable "source_package" {
  description = "Path of Lambda package zip"
  default     = ""
}

variable "source_s3_bucket" {
  description = "S3 bucket containing Lambda zip"
  default     = ""
}

variable "source_s3_key" {
  description = "S3 key of Lambda zip"
  default     = ""
}

variable "included_clusters" {
  description = "Comma separated list of clusters to monitor"
  default     = "all"
}

variable "tags" {
  description = "Map of tags to apply to AWS resources"
  type        = map
}
