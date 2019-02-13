# User edited file "terraform.tf" file

module "vars" {
	source = "../../vars"
}

terraform {
	backend "s3" {
	encrypt = true
	bucket = "${module.vars.web_remote_state_bucket}"
	dynamodb_table = "${module.vars.web_remote_state_dynamodb_table}"
	region = "eu-west-1"
	key = "${module.vars.web_remote_state_key}"
	}
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock-for-web" {
	name = "${module.vars.web_remote_state_dynamodb_table}"	# This should be unique for each type of locks
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