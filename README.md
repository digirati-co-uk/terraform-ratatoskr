# Ratatoskr

Terraform module for AWS Lambda function that communicates ECS deployment events to a Slack webhook.

| Variable          | Description                                              | Default |
|-------------------|----------------------------------------------------------|---------|
| prefix            | Prefix to give to AWS resources                          |         |
| tags              | Map of tags to apply to AWS resources                    |         |
| slack_api_token   | Slack API token                                          |         |
| slack_channel     | Slack channel name to emit messages into                 |         |
| source_s3_bucket  | S3 Bucket containing Lambda package zip                  |         |
| source_s3_key     | S3 key of Lambda package zip                             |         |
| source_package    | Path of Lambda package zip (skip if provided S3 details) |         |
| included_clusters | Comma separated list (or "all") of clusters to monitor   | all     |

## Output

| Name      | Description                     |
|-----------|---------------------------------|
| role_name | IAM Role name of Ratatoskr task |

## Example - local file based

```
module "ratatoskr" {
  source = "git::https://github.com/digirati-co-uk/terraform-ratatoskr.git//"

  prefix          = "${var.prefix}"
  slack_api_token = "${var.ratatoskr_slack_api_token}"
  slack_channel   = "${var.ratatoskr_slack_channel}"
  source_package  = "files/ratatoskr/ratatoskr-201904252319.zip"

  tags = {
    "Project" = "${var.project}"
  }
}
```

## Example - S3 based

```
module "ratatoskr" {
  source = "git::https://github.com/digirati-co-uk/terraform-ratatoskr.git//"

  prefix           = "${var.prefix}"
  slack_api_token  = "${var.ratatoskr_slack_api_token}"
  slack_channel    = "${var.ratatoskr_slack_channel}"
  source_s3_bucket = "ch-public-objects"
  source_s3_key    = "ratatoskr/ratatoskr-201904252319.zip"

  tags = {
    "Project" = "${var.project}"
  }
}
```

## Building

This assumes the use of the Python application at https://github.com/digirati-co-uk/ecs-slack-notifications which is a fork of https://github.com/Fullscreen/ecs-slack-notifications with a change or two added (also MIT license).

- Ensure Python 2.7 and `pip` installed
- Clone repo
- Change to repo folder
```
cd ecs-slack-notifications
```
- Install requirements local to the folder
```
pip install -r requirements.txt --target .
```
- Archive folder to timestamped ZIP file
```
zip -r9 ../ratatoskr-`date +%Y%m%d%H%M`.zip .
```

- Then place that zip file in your Terraform project and reference in the module call detailed above.
- Alternatively, place zip file in an S3 bucket that the task will have access to and use S3 parameters to pass details.
