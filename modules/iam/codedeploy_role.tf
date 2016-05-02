/* Service Role */
resource "aws_iam_role" "codedeploy_service_role" {
  name   = "codedeploy_service_role"
  assume_role_policy = "${file("${path.module}/files/code_deploy_policy.json")}"
}

resource "aws_iam_policy_attachment" "codedeploy_managed_policy" {
  name       = "codedeploy_managed_policy_attachment"
  roles      = ["${aws_iam_role.codedeploy_service_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}
