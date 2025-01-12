# **S3 Static Site with CORS** 

_Terraform and AWS project used to provision two buckets that support each other with CORS._

---

## Table of Contents
1. [Overview](#overview)
2. [Workflow](#workflow)
3. [Project Structure](#project-structure)


## Overview

This project provisions two S3 buckets with Terraform:

- **Frontend Bucket**: Configured as a static website.
- **Host Bucket**: Configured to support Cross-Origin Resource Sharing (CORS) for serving images.

The **"frontend"** bucket contains a dynamically generated `index.html` page, which is rendered using the `templatefile()` function in Terraform. The page references images stored in the **"host"** bucket, demonstrating the CORS feature.

This setup is an example of Terraform's `templatefile()` function, and it showcases how to use it to dynamically render an HTML file with references to S3 objects. 

The Terraform script also outputs the host object URLs and the frontend website endpoint for easy access.

## Workflow

To get started with this project, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/aaron-dm-mcdonald/s3_static_site_cors.git

2. Move into the directory:
   ```bash
   cd s3_static_site_cors

3. Edit ```1-auth.tf``` to include your region and an S3 backend. The bucket names are generated with random suffixes. 

4. Begin terraform workflow:
    - ```terraform init```
    - ```terraform validate```
    - ```terraform plan```
    - ```terraform apply -auto-approve```



## Project Structure

- ./tfe-actions-s3
    - .github/
        - dependabot.yml
        - workflows/
            - terraform-apply.yml
            - terraform-plan.yml
            - terraform.yml
            - your-fork.yml
    - .gitignore
    - 0-var.tf
    - 1-auth.tf
    - 2a-bucket.tf
    - 2b-bucket.tf
    - output.tf
    - README.md
    - website/
        - frontend/
            - error.html
            - index.html.tmpl
            - styles.css
        - host/
            - images/
                - image-1.jpg
                - image-2.jpg
                - image-3.jpg# tfe-actions-test
