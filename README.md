Sample Project to use Terraform to learn Infrastructure as Code (IaC)

To try this web server, you will need your own AWS account and ACCESS keys

Create an account and login
https://console.aws.amazon.com/

Go to Security Credentials and create an [Access Key, Secret Key] Pair. Don't hard code this as it can raise security concerns, best practice is to type this in a .env file to use in your project, or EXPORT directly to your terminal's seesion as an env variable

For just the sake of testing in local machine, you can add these 3 params to the Provider block and hard code
provider "aws" {
  region     = "us-west-2"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}
You can delete the access key after testing

First step is to Run `terraform init`

This will initialize the terraform environment and locate `aws` as the Provider, install the aws plugins and api-related code to communicate with your aws account. Upon authentication with your account via the access key, you can run terraform commands

Run `terraform apply` to create the infrastructure
Head over to your aws console to see if you created the server instance, the vpc, internet gateway, routing tables, network interface, and the other resources that were declared in the `.tf` file

Find the ip address where this web server is hosted, and you can open it in browser to see a simple `Hello World` text being displayed

I have installed `apache2` in a virtual `Ubuntu Server` using aws. A simple bash script echos the text to the index/html page, which gets shown as content on the webpage

Finally, try different Terraform commands to learn more about how Terraform can help in Automating Infrastructure Provisioning
