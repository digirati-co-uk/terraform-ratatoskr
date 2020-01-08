resource "aws_dynamodb_table" "ratatoskr_instance_state" {
  name     = "${var.prefix}-ratatoskr-instance-state"
  hash_key = "containerInstanceArn"

  attribute {
    name = "containerInstanceArn"
    type = "S"
  }

  ttl {
    attribute_name = "TTL"
    enabled        = true
  }

  read_capacity  = 2
  write_capacity = 2

  tags = "${var.tags}"
}

resource "aws_dynamodb_table" "ratatoskr_task_state" {
  name     = "${var.prefix}-ratatoskr-task-state"
  hash_key = "taskArn"

  attribute {
    name = "taskArn"
    type = "S"
  }

  ttl {
    attribute_name = "TTL"
    enabled        = true
  }

  read_capacity  = 2
  write_capacity = 2

  tags = "${var.tags}"
}

resource "aws_dynamodb_table" "ratatoskr_task_digest" {
  name     = "${var.prefix}-ratatoskr-task-digest"
  hash_key = "startedBy"

  attribute {
    name = "startedBy"
    type = "S"
  }

  ttl {
    attribute_name = "TTL"
    enabled        = true
  }

  read_capacity  = 2
  write_capacity = 2

  tags = var.tags
}
