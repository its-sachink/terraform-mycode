provider "aws" {
	region = "eu-west-1"
}

module "vars" {
	source = "../../vars"	
}

module "webserver-cluster" {
	source = "../../../modules/services/webserver-cluster"

	cluster_name = "webservers-prod"
	db_remote_state_bucket = "${module.vars.db_remote_state_bucket}"
	db_remote_state_key = "${module.vars.db_remote_state_key}"

	instance_type = "t2.micro" 	# we can keep it as m4.large
	min_size = 2
	max_size = 4
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
	scheduled_action_name = "scale-out-during-business-hours"
	min_size = 2
	max_size = 4
	desired_capacity = 4
	recurrence = "0 9 * * *"

	autoscaling_group_name = "${module.webserver-cluster.asg_name}"
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
	scheduled_action_name = "scale-in-at-night"
	min_size = 1
	max_size = 2
	desired_capacity = 2
	recurrence = "0 17 * * *"

	autoscaling_group_name = "${module.webserver-cluster.asg_name}"
}

