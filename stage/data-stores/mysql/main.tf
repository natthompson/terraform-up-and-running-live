provider "aws" {
	region				= "us-east-2"
}

terraform {
	backend "s3" {
		bucket					= "com.natthompson.terraform-up-and-running-state-2ed"
		key						= "stage/data-stores/mysql/terraform.tfstate"
		region					= "us-east-2"

		dynamodb_table			= "terraform-up-and-running-locks"
		encrypt					= true
	}
}

data "aws_secretsmanager_secret_version" "db_password" {
	secret_id					= "mysql-master-password-stage"
}

resource "aws_db_instance" "example" {
	identifier_prefix			= "terraform-up-and-running"
	engine						= "mysql"
	allocated_storage			= 10
	instance_class				= "db.t2.micro"
	name						= "example_database"
	username					= "admin"
	password					= var.db_password
}