provider "aws" {
	region						= "us-east-2"
}

terraform {
	backend "s3" {
		bucket					= "com.natthompson.terraform-up-and-running-state-2ed"
		key						= "workspaces-example/terraform.tfstate"
		region					= "us-east-2"

		dynamodb_table			= "terraform-up-and-running-locks"
		encrypt					= true
	}
}

resource "aws_s3_bucket" "terraform_state" {
	bucket					= "com.natthompson.terraform-up-and-running-state-2ed"

	# Enable versioning so we can see the full revision history
	# of our state files
	versioning {
		enabled					= true
	}

	# Enable server side encryption by default
	server_side_encryption_configuration {
		rule {
			apply_server_side_encryption_by_default	{
				sse_algorithm	= "AES256"
			}
		}
	}
}

resource "aws_dynamodb_table" "terraform-locks" {
	name						= "terraform-up-and-running-locks"
	billing_mode				= "PAY_PER_REQUEST"
	hash_key					= "LockID"

	attribute {
		name					= "LockID"
		type					= "S"
	}
}

