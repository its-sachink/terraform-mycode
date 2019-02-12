# User edited file

provider "aws" {
	region = "eu-west-1"
}

resource "aws_s3_bucket" "terraform_state" {
	bucket = "tf-state-prod-29-jan-19"

	versioning {
		enabled = true
	}

	lifecycle {
		prevent_destroy = true
	}

	tags {
		Name = "S3 Remote Terraform State"
	}
}

# Dynamodb database for maintaing the locks.

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

########### following is the sequence
#1 : First create the resource
#2 : Create the bucket
#3 : Then create the backend
#4 : Add "dynamodb" database to the main.tf file
#5 : edit "terraformlock.tf" to include the "dynamodb" database in the "s3" configuration