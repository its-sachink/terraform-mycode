# User edited file "terraform.tf" file

terraform {
	backend "s3" {
	encrypt = true
	bucket = "tf-state-prod-29-jan-19"
	dynamodb_table = "terraform-state-lock-for-db"
	region = "eu-west-1"
	key = "prod/global/s3/terraform.tfstate"
	}
}
