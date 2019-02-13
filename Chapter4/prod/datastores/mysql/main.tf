# main.tf

provider "aws" {
	region = "eu-west-1"
}

resource "aws_db_instance" "example" {
	engine = "mysql"
	allocated_storage = 10
	instance_class = "db.t2.micro"
	name = "example_database"
	username = "admin"
	password = "${var.db_password}"
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



########### following is the sequence
#1 : First create the resource
#2 : Create the bucket
#3 : Then create the s3 backend - run "terraform init" here
#4 : Add "dynamodb" database to the main.tf file	- run "terraform apply" here
#5 : edit "terraformlock.tf" to include the "dynamodb" database in the "s3" configuration - again run "terraform init" here.