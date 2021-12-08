resource "aws_lambda_function" "ratatoskr_file" {
  count            = "${length(var.source_package) > 0 ? 1 : 0}"
  function_name    = "${var.prefix}-ratatoskr"
  handler          = "main.lambda_handler"
  runtime          = "python3.9"
  filename         = "${var.source_package}"
  source_code_hash = "${base64sha256(file(var.source_package))}"

  role = "${aws_iam_role.ratatoskr_exec_role.arn}"

  environment {
    variables = {
      SLACK_API_TOKEN                = "${var.slack_api_token}"
      SLACK_CHANNEL                  = "${var.slack_channel}"
      INCLUDED_CLUSTERS              = "${var.included_clusters}"
      TABLE_TASK_STATE               = "${aws_dynamodb_table.ratatoskr_task_state.name}"
      TABLE_TASK_DIGEST              = "${aws_dynamodb_table.ratatoskr_task_digest.name}"
      TABLE_CONTAINER_INSTANCE_STATE = "${aws_dynamodb_table.ratatoskr_instance_state.name}"
    }
  }
}

resource "aws_lambda_function" "ratatoskr_s3" {
  count         = "${length(var.source_package) > 0 ? 0 : 1}"
  function_name = "${var.prefix}-ratatoskr"
  handler       = "main.lambda_handler"
  runtime       = "python2.7"
  s3_bucket     = "${var.source_s3_bucket}"
  s3_key        = "${var.source_s3_key}"

  role = "${aws_iam_role.ratatoskr_exec_role.arn}"

  environment {
    variables = {
      SLACK_API_TOKEN                = "${var.slack_api_token}"
      SLACK_CHANNEL                  = "${var.slack_channel}"
      INCLUDED_CLUSTERS              = "${var.included_clusters}"
      TABLE_TASK_STATE               = "${aws_dynamodb_table.ratatoskr_task_state.name}"
      TABLE_TASK_DIGEST              = "${aws_dynamodb_table.ratatoskr_task_digest.name}"
      TABLE_CONTAINER_INSTANCE_STATE = "${aws_dynamodb_table.ratatoskr_instance_state.name}"
    }
  }
}

locals {
  lambda_function_name = "${element(concat(aws_lambda_function.ratatoskr_file.*.function_name, aws_lambda_function.ratatoskr_s3.*.function_name), 0)}"
  lambda_function_arn  = "${element(concat(aws_lambda_function.ratatoskr_file.*.arn, aws_lambda_function.ratatoskr_s3.*.arn), 0)}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ratatoskr" {
  statement_id  = "AllowExecutionFromCloudwatch"
  action        = "lambda:InvokeFunction"
  function_name = "${local.lambda_function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.ecs.arn}"
}
