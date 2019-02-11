provider "aws" {
	region = "eu-west-1"
}

module webserver-cluster {
	source = "../../../modules/services/"

	cluster_name = "webserver-stage"
	db_remote_state_bucket = "tf-state-29-jan-19"
	db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"

	instance_type = "t2.micro"
	min_size = 2
	max_size = 2
}