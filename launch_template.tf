resource "aws_launch_template" "launch_template" {
  name          = "asg_launch_config"
  instance_type = var.instance_type
  image_id      = var.ami
  key_name      = var.key_name
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 8
      encrypted             = true
      kms_key_id            = aws_kms_key.kms_ebs.arn
      delete_on_termination = true
    }
  }

  network_interfaces {
    security_groups             = [aws_security_group.instance.id]
    associate_public_ip_address = true
  }
  user_data = base64encode(<<-EOF
    #!/bin/bash
      echo DATABASE_URL=${var.db_dialect}://${var.db_username}:${var.db_password}@${aws_db_instance.postgresql_instance.endpoint}/${var.db_name} >> /etc/environment
      echo S3_BUCKET_NAME=${aws_s3_bucket.private.bucket} >> /etc/environment
      systemctl restart webapp.service
    EOF
  )
  iam_instance_profile {
    name = aws_iam_instance_profile.profile.name
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.instance_name
    }
  }
}

resource "aws_kms_key" "kms_ebs" {
  description             = "KMS key for EBS"
  policy                  = local.policy_kms_json
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_ebs_default_kms_key" "ebs_default_kms" {
  key_arn    = aws_kms_key.kms_ebs.arn
  depends_on = [aws_kms_key.kms_ebs]
}

