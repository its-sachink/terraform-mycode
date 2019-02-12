###### output variables "ARN of s3 bucket"

output "tfstate_s3_arn" {
	value = "${aws_s3_bucket.terraform_state.arn}"
}
