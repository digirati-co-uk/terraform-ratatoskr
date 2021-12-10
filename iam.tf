data "aws_iam_policy_document" "ratatoskr_exec_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ratatoskr_exec_role" {
  name               = "${var.prefix}-ratatoskr-exec-role"
  assume_role_policy = data.aws_iam_policy_document.ratatoskr_exec_role.json
}

resource "aws_iam_role_policy_attachment" "ratatoskr_logging" {
  role       = aws_iam_role.ratatoskr_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "ratatoskr_abilities" {
  statement {
    actions = [
      "dynamodb:Batch*",
      "dynamodb:GetItem*",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:PutItem",
    ]

    resources = [
      aws_dynamodb_table.ratatoskr_task_state.arn,
      aws_dynamodb_table.ratatoskr_task_digest.arn,
      aws_dynamodb_table.ratatoskr_instance_state.arn,
    ]
  }

  statement {
    actions = [
      "ecs:Describe*",
      "ecs:List*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ecr:DescribeRespositories",
      "ecr:DescribeImages",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "ratatoskr_abilities" {
  name   = "${var.prefix}-ratatoskr"
  role   = aws_iam_role.ratatoskr_exec_role.name
  policy = data.aws_iam_policy_document.ratatoskr_abilities.json
}
