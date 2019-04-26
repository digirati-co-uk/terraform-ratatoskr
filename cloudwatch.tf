resource "aws_cloudwatch_event_target" "ecs_ratatoskr" {
  target_id = "${var.prefix}-ecs-ratatoskr"
  rule      = "${aws_cloudwatch_event_rule.ecs.name}"
  arn       = "${aws_lambda_function.ratatoskr.arn}"
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
