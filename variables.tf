data "aws_caller_identity" "current" {}

locals {
  policy_kms_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "Allow access for Key Administrators",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
        },
        "Action" : [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow use of the key",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/jay"
          ]
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow attachment of persistent resources",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/jay"
          ]
        },
        "Action" : [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ],
        "Resource" : "*",
        "Condition" : {
          "Bool" : {
            "kms:GrantIsForAWSResource" : "true"
          }
        }
      }
    ]
  })
}
variable "region" {
  type = string
}

variable "profile" {
  type = string
}
variable "vpc_cidr_block" {
  type = string
}

data "aws_availability_zones" "available" {
  state = "available"
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "private_subnet_cidr" {
  type = list(string)
}

variable "application_security_group_ingress" {
  type = list(number)
}
locals {
  azs                 = data.aws_availability_zones.available.names
  public_cidr_blocks  = var.public_subnet_cidr
  private_cidr_blocks = var.private_subnet_cidr
  ingress_port        = var.application_security_group_ingress
}

variable "db_identifier" {
  type = string
}
variable "db_engine" {
  type = string
}
variable "db_engine_version" {
  type = string
}
variable "db_instance_class" {
  type = string
}
variable "db_name" {
  type = string
}
variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
}

variable "db_allocated_storage" {
  type = number
}

variable "db_pg_name" {
  type = string
}
variable "db_pg_family" {
  type = string
}
variable "db_pg_description" {
  type = string
}

variable "db_dialect" {
  type = string
}

variable "s3_acl" {
  type = string
}

variable "s3_lifecycle_rule_id" {
  type = string
}
variable "s3_lifecyle_enabled" {
  type = bool
}

variable "s3_lifecycle_rule_duration" {
  type = number
}

variable "s3_lifecycle_rule_storage_class" {
  type = string
}

variable "ami" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "root_blook_device_size" {
  type = number
}

variable "domain_name" {
  type = string
}
variable "port_HTTPS" {
  type    = string
  default = "443"
}

variable "port_application" {
  type    = string
  default = "5000"
}

data "aws_iam_policy" "cloud_watch_access" {
  name = "CloudWatchAgentServerPolicy"
}