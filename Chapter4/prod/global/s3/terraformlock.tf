# User edited file "terraform.tf" file

terraform {
	backend "s3" {
	encrypt = true
	bucket = "tf-state-prod-29-jan-19"
	dynamodb_table = "terraform-state-lock-s3"
	region = "eu-west-1"
	key = "prod/global/s3/terraform.tfstate"
	}
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock-for-s3" {
	name = "terraform-state-lock-s3"
	hash_key = "LockID"
	read_capacity = 20
	write_capacity = 20

	attribute {
		name = "LockID"
		type = "S"
	}

	tags {
		Name = "DyanmoDB terraform State Lock"
	}
}