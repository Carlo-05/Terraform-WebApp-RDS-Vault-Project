# **Terraform: WebApp RDS Vault Project**
-	This project provisions a full infrastructure using Terraform including, VPC, EC2, RDS, Auto Scaling Groups (ASG), and Application Load Balancer. Furthermore, certain resources such as S3, DynamoDB and SSM Parameter configuration were manually created to support Terraform backend, ALB logs, and RDS credentials configuration.

## **Purpose:**
-	The goal of this project is to showcase Infrastructure as Code (IaC) best practices using Terraform, with a focus on modular design, environment-based separation, and secure management of state and secrets.
#### *Note: Some services may incur costs beyond AWS Free Tier account limits. Please keep this in mind.*

## **Feature:**
-	**Dev**

    -	A lightweight HTML-based web application deployed on an EC2 instance that retrieves its Instance ID and Public IP, and logs the data securely into an Amazon RDS (MySQL) database.
    
    -	Sensitive credentials are managed by HashiCorp Vault.
    -	Implements a Bastion Host to securely access AWS resources (such as EC2 instances and RDS databases) in isolated subnets.
    -	Implements remote state management for Terraform using Amazon S3 as the backend.

-	**Prod**

    -	A lightweight HTML-based web application deployed on an EC2 Auto Scaling Group (ASG) that retrieves Instance ID’s and Public IPs, and logs the data securely into an Amazon RDS Multi-AZ (MySQL) database.
    -	It uses Application Load Balancer (ALB) to manage traffic into your Auto Scaling Group (ASG).
    -	Implements Application Load Balancer (ALB) access logging, configured to store detailed traffic logs in a dedicated Amazon S3 bucket. This enables auditing, monitoring, and performance analysis of incoming requests to your web application.
    -	Sensitive credentials are managed by HashiCorp Vault.
    -	Implements a Bastion Host to securely access AWS resources (such as EC2 instances and RDS databases) in isolated subnets.
    -	Implements remote state management for Terraform using Amazon S3 as the backend, with DynamoDB for state locking and consistency, enabling safe, concurrent infrastructure deployments in a collaborative environment.

## **Architecture diagram**

- **Project overview**
  
    <div align="left">
    <img src="https://github.com/Carlo-05/Terraform-WebApp-RDS-Vault-Project/blob/064d8aa47e5fe889511c5497190fca3464fe8587/Other%20documents/pictures/ReadMe/tree.png?raw=true" alt="Project overview"style="width: 20%; height: auto;">
    </div>


- **Dev:**

    <div align="left">
    <img src="https://github.com/Carlo-05/Terraform-WebApp-RDS-Vault-Project/blob/064d8aa47e5fe889511c5497190fca3464fe8587/Other%20documents/pictures/ReadMe/dev.png?raw=true" alt="Project overview"style="width: 60%; height: auto;">
    </div>
 
- **Prod:**

    <div align="left">
    <img src="https://github.com/Carlo-05/Terraform-WebApp-RDS-Vault-Project/blob/064d8aa47e5fe889511c5497190fca3464fe8587/Other%20documents/pictures/ReadMe/prod.png?raw=true" alt="Project overview"style="width: 60%; height: auto;">
    </div>
 

## **Technologies used**

**Terraform**
-	an open-source "Infrastructure as Code" (IaC) tool, is used to automate the provisioning and management of cloud and on-premises infrastructure by defining infrastructure as code, enabling consistent and repeatable deployments.
-	Terraform documentation used in building this project: 
    https://registry.terraform.io/providers/hashicorp/aws/latest/docs

**AWS**
-	cloud computing service provider which is offered by Amazon
-	cloud services used in this project are VPC, EC2, RDS, Auto Scaling Group (ASG), S3, DynamoDB, IAM, and Application Load Balancer (ALB).
-	AWS Command Line Interface (CLI) documentation used in building this project: https://docs.aws.amazon.com/cli/

**Git & GitHub**
-	Used for version control, collaboration, and project hosting.
-	To allow users to clone and explore the project.

**Visual Studio Code**
-	is a powerful integrated development environment (IDE) created by Microsoft. It offers features like code editing, debugging, version control integration, and rich extensions, making it a versatile tool for developers of all levels.

**Linux OS**
-	Project development using Terraform on Linux environment.
-	Created several scripts and sql file needed for this project.

**AI Assistance**
-	Used as a learning and development aid for troubleshooting and following best practices in Terraform and AWS infrastructure design.
-	Github Copilot, ChatGPT.

**Terraform Files**
-	**main.tf** – main infrastructure logic.
-	**variables.tf** – variable declarations.
-	**outputs.tf** – values exposed after deployment.
-	**backend.tf** – remote backend configuration.
-	**terraform.tfvars** – actual values for the declared variables.

## **Other Files**
**Project.sh**
-   This script runs in EC2 and ASG module.
-	This script dynamically detects whether the OS of the instance is Linux 2 or Ubuntu. It installs necessary system update and dependencies including aws-cli, mysql, and apache.    
-   Creates ec2details.sql which creates ec2_details table into your RDS MySQL.
-   Fetch AWS metadata which includes instance id, instance public ip, region, and token.
-	Fetch RDS MySQL credentials from SSM parameters.
-	Import employees.sql and ec2details.sql into the database using the RDS MySQL credentials.
-	Insert instance id and instance public ip into the MySQL table called ec2_details.
-	Creates index.html that shows the ec2 information like instance id and public ip.

**Vault-installer.sh**
-   This script runs in Bastion module.
-	This script dynamically detects whether the OS of the instance is Linux 2 or Ubuntu. Moreover, it installs OS update and Hashicorp Vault.

**Employees.sql**
-	Creates employees table and inserts employee’s id, name, and role.

**s3policy.json**
-   s3 bucket policy that needs to be attached to this project s3 bucket.
-	Allows s3 full access and Application Load Balancer (ALB) log delivery into your bucket. Ensures exclusive access for your administrator user.

## **Modules Explanation**
**Module** – is a self-contained Terraform module, with well-organized configuration files to 
    manage infrastructure as code.

**ALB**
- Application Load Balancer. Allows http traffic to the WebApp Auto Scaling Group.

**ASG**
-	Auto scaling group. Has a target scaling policy, that will scale out when the average CPU utilization is >= 50%. Furthermore, it scales out when the average CPU utilization is <50%.
-	Download and install necessary dependencies via user data.

**BASTION**
-	Bastion host instance, is it use to securely connect to the instances and databases without exposing them to public
-	Download and install necessary dependencies via user data.
	
**EC2**
-	WebApp instance, is displays its own instance id and public ip in a web browser.
-	Download and install necessary dependencies via user data.
	
**IAM-ROLE**
-	IAM role that is attached to WebApp instance. It has a policy that includes AmazonEC2ReadOnlyAccess, AmazonRDSFullAccess, AmazonSSMManagedInstanceCore, and CloudWatchFullAccess.
-	This is the policy needed for project.sh in order for it to run smoothly and for the ASG target scaling policy to perform its function.
	
**KEYPAIR**
-	Create a key pair using the keys generated on your local machine. This process will import your public key into AWS, enabling authentication with the private key stored locally and the corresponding public key in AWS.

**NAT**
-	NAT Gateway, it enables the resources in private subnets to access the internet while preventing inbound traffic from external sources.

**RDS-MYSQL**
-	RDS MySQL database
-	Stores instance id’s, public ip, and employee’s data.

**SECURITYGROUPS**
-	Centralize security group module, where all of the resource’s security group are stored.

**VAULT-INSTANCE**
-	Use to store any sensitive information. For our project, it will store the employee’s login password.

**VPC**
-	Our project virtual network infrastructure. It includes 2 public subnets, 2 private subnets, etc. Please see picture of dev and prod for reference.

## **How to use:**

- [Prerequisites (WSL, VS Code, Terraform, and AWS cli setup).](https://github.com/Carlo-05/Terraform-WebApp-RDS-Vault-Project/blob/main/Other%20documents/md%20files/1.%20Prerequisites.md)
- [First step (create s3, ssm parameters store, dynamodb manually).](https://github.com/Carlo-05/Terraform-WebApp-RDS-Vault-Project/blob/main/Other%20documents/md%20files/2.%20First%20step.md)
- [How to initialize and apply.](https://github.com/Carlo-05/Terraform-WebApp-RDS-Vault-Project/blob/main/Other%20documents/md%20files/3.%20How%20to.md)
- [Auto Scaling Group Testing.](https://github.com/Carlo-05/Terraform-WebApp-RDS-Vault-Project/blob/main/Other%20documents/md%20files/4.%20ASG%20test.md)
- [Review RDS MySQL.](https://github.com/Carlo-05/Terraform-WebApp-RDS-Vault-Project/blob/main/Other%20documents/md%20files/5.%20MySQL%20verification.md)
- [Vault setup.](https://github.com/Carlo-05/Terraform-WebApp-RDS-Vault-Project/blob/main/Other%20documents/md%20files/6.%20Vault%20Setup.md)
