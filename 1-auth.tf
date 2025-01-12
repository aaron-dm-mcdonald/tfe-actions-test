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

 
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"

}

