resource "aws_iam_user_policy" "packer_build_policy" {
  name   = "packer_build_policy"
  user   = "${aws_iam_user.packer_build_user.name}"
  policy = "${file("${path.module}/files/packer_builder_policy.json")}"
}

resource "aws_iam_user" "packer_build_user" {
  name = "packer_build_user"
  path = "/"
}

resource "aws_iam_access_key" "packer_build_user" {
  user = "${aws_iam_user.packer_build_user.name}"
}
