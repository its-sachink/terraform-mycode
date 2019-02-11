# User edited file

provider "aws" {
	region = "eu-west-1"
}

resource "aws_s3_bucket" "terraform_state" {
	bucket = "tf-state-29-jan-19"

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


output "tfstate_s3_arn" {
	value = "${aws_s3_bucket.terraform_state.arn}"
}
