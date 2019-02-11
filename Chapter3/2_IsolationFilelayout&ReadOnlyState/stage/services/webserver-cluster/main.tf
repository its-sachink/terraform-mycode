provider "aws" {
	region = "eu-west-1"
}

data "aws_availability_zones" "all" {
	
}

data "template_file" "user_data" {
	template = "${file("user-data.sh")}"

	vars {
		server_port = "${var.server_port}"
		db_address = "${data.terraform_remote_state.db.address}"
		db_port = "${data.terraform_remote_state.db.port}"
	}
}

data "terraform_remote_state" "db" {
	backend = "s3"

	config {
		bucket = "tf-state-29-jan-19"
		key = "stage/data-stores/mysql/terraform.tfstate"
		region = "eu-west-1"
	}
}

resource "aws_launch_configuration" "example" {
	image_id = "ami-08935252a36e25f85"
	instance_type = "t2.micro"
	security_groups = ["${aws_security_group.instance.id}"]
	user_data = "${data.template_file.user_data.rendered}"

	lifecycle {
		create_before_destroy = true
	}
}

resource "aws_autoscaling_group" "example" {
	launch_configuration = "${aws_launch_configuration.example.id}"
	load_balancers = ["${aws_elb.example.id}"]
	availability_zones = ["${data.aws_availability_zones.all.names}"]
	health_check_type = "ELB"

	min_size = 2
	max_size = 10

	tag {

		key = "Name"
		value = "terraform-asg-example"
		propagate_at_launch = true
	}
}


resource "aws_elb" "example" {
	
	name = "terraform-asg-example"
	security_groups = ["${aws_security_group.elb.id}"]
	availability_zones = ["${data.aws_availability_zones.all.names}"]

	listener {
		lb_port = 80
		lb_protocol = "http"
		instance_port = "${var.server_port}"
		instance_protocol = "http"
	}

	health_check {
		healthy_threshold = 2
		unhealthy_threshold = 2
		timeout = 3
		interval = 30
		target = "HTTP:${var.server_port}/"
	}
}



resource "aws_security_group" "elb" {
	
	name = "terraform-example-elb"

	ingress = {

		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "instance" {
	
	name = "terraform-example-instance"

	ingress {
		from_port = "${var.server_port}"
		to_port = "${var.server_port}"
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	lifecycle {
		create_before_destroy = true
	}
}


variable "server_port" {
	description = "The port the server will use for HTTP requests"
	default = 8080
}

output "elb_dns_name" {
	description = "The Public IP address of a server"
	value = "${aws_elb.example.dns_name}"
}
