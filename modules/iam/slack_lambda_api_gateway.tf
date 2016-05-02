/* Allows Lambda Execution, grants access to AWS Services */
resource "aws_iam_role_policy" "api_gateway_lambda_exec_policy" {
  name = "api-gateway-lambda-exec-policy"
  role = "${aws_iam_role.api_gateway_lambda_exec.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:*"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "api_gateway_lambda_exec" {
  name = "api-gateway-lambda-exec"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "slack_lambda" {
  name = "slack-iam-lambda"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "api_gateway_lambda_invoke_policy" {
  name = "api-gateway-lambda-invoke-policy"
  role = "${aws_iam_role.api_gateway_lambda_invoke.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "lambda:InvokeFunction"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "api_gateway_lambda_invoke" {
  name = "api-gateway-lambda-invoke"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

output "aws_iam_role_slack_lambda_arn" {
  value = "${aws_iam_role.slack_lambda.arn}"
}

