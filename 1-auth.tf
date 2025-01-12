terraform {

  cloud { 
    
    organization = "test-gh-actions" 

    workspaces { 
      name = "learn-terraform-github-actions" 
    } 
  } 


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use latest version if possible
    }
  }

  backend "s3" {
    bucket  = "tf-backend-4357232"                 # Name of the S3 bucket
    key     = "static-website-cors-011225.tfstate" # The name of the state file in the bucket
    region  = "us-east-1"                          # Use a variable for the region
    encrypt = true                                 # Enable server-side encryption (optional but recommended)
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"

}

