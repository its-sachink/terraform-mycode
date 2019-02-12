variable "bucket_region" {
	description = "Region of the bucket"
	default = "eu-west-1"
}

variable "web_remote_state_bucket" {
	description = "The password for the database"
	default = "tf-state-prod-29-jan-19"
}

variable "web_remote_state_key" {
	description = "web key for prod"
	default = "prod/services/webserver-cluster/terraform.tfstate"
}

variable "web_remote_state_dynamodb_table" {
	description = "Dynamodb table name for prod"
	default = "terraform-state-lock-for-web"
}

variable "db_remote_state_bucket" {
	description = "Database tf state bucket name"
	default = "tf-state-prod-29-jan-19"
}

variable "db_remote_state_key" {
	description = "Database tf state key"
	default = "prod/data-stores/mysql/terraform.tfstate"
}