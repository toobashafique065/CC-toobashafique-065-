Issue 1: Terraform command not found

Cause: Terraform not installed or PATH not set
Fix:

terraform --version


Install Terraform and add to PATH.

Issue 2: AWS credentials error

Cause: AWS CLI not configured
Fix:

aws configure

Issue 3: EC2 instance not accessible via browser

Cause: Port 80 not open
Fix:

Check Security Group inbound rules

Ensure HTTP (80) is allowed

Issue 4: Permission denied when SSH

Fix:

chmod 400 key.pem

Issue 5: Nginx/Apache not running

Cause: User-data script failed
Fix:

sudo systemctl status nginx
sudo systemctl status httpd

Issue 6: Terraform state errors

Fix:

terraform init
terraform validate
terraform plan