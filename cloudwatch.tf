resource "aws_cloudwatch_event_target" "ecs_ratatoskr" {
  count     = "${length(var.source_package) > 0 ? 1 : 0}"
  target_id = "${var.prefix}-ecs-ratatoskr"
  rule      = "${aws_cloudwatch_event_rule.ecs.name}"
  arn       = "${local.lambda_function_arn}"
}

resource "aws_cloudwatch_event_rule" "ecs" {
  name = "${var.prefix}-ecs-ratatoskr-events"

  event_pattern = <<PATTERN
{
  "source" : [
    "aws.ecs"
  ],
  "detail-type": [
    "ECS Task State Change",
    "ECS Container Instance State Change"
  ]
}
PATTERN
}
