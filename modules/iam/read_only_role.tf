variable "account_id" {}

/*
Read-only role suitable for general access to the AWS console

The assume_read_only policy should be manually attached to newly created
accounts to provide this access.
*/

resource "aws_iam_policy" "assume_read_only" {
  name        = "assume_read_only"
  description = "Assume a read only role"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::${var.account_id}:role/read_only_role"
    }
  ]
}
EOF
}

resource "aws_iam_role" "read_only_role" {
  name = "read_only_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${var.account_id}:root"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "read_only_policy" {
  name   = "read_only_policy"
  role   = "${aws_iam_role.read_only_role.id}"
  policy = "${file("${path.module}/files/read_only_policy.json")}"
}
