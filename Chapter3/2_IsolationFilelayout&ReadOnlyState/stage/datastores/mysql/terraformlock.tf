# terraformlock.tf

terraform {
	backend "s3" {
	encrypt = true
	bucket = "tf-state-29-jan-19"
	region = "eu-west-1"
	key = "stage/data-stores/mysql/terraform.tfstate"
	}
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock-for-db" {
	name = "terraform-state-lock-for-db" # This should be unique for each type of locks
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