data "aws_acm_certificate" "issued" {
  domain   = "${var.profile}.${var.domain_name}"
  statuses = ["ISSUED"]
}
resource "aws_lb" "application_loadbalancer" {
  name               = "applicationlb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.loadbalancer_securitygroup.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]
  tags = {
    Application = "WebApp"
  }
}

resource "aws_lb_target_group" "loadbalancer_targetgroup" {
  name     = "lbtg"
  port     = var.port_application
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    path = "/healthz"
  }
}

resource "aws_lb_listener" "front_end_secured" {
  load_balancer_arn = aws_lb.application_loadbalancer.arn
  port              = var.port_HTTPS
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.issued.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.loadbalancer_targetgroup.arn
  }
}

resource "aws_security_group" "loadbalancer_securitygroup" {
  name_prefix = "application_lb_sg"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = var.port_HTTPS
    to_port     = var.port_HTTPS
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "to_ec2" {
  type                     = "egress"
  from_port                = var.port_application
  to_port                  = var.port_application
  protocol                 = "tcp"
  security_group_id        = aws_security_group.loadbalancer_securitygroup.id
  source_security_group_id = aws_security_group.instance.id
}
