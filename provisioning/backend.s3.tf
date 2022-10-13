# WARN: The s3 backend currently does not support state locking!
# See:
#   - https://www.terraform.io/language/settings/backends/s3
#   - https://github.com/hashicorp/terraform/issues/27070
terraform {
  backend "s3" {
    key = "default/terraform"
  }
}
