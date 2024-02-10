# provider info and profile
profile = ""
region  = ""

#network resources values
vpc_cidr_block      = ""
public_subnet_cidr  = [""]
private_subnet_cidr = [""]


#aws_db_instance resources values 
db_identifier        = ""
db_engine            = ""
db_engine_version    = ""
db_instance_class    = ""
db_name              = ""
db_username          = ""
db_password          = ""
db_allocated_storage = null

db_dialect = ""

#aws_db_parameter_group resources values
db_pg_name        = ""
db_pg_family      = ""
db_pg_description = ""

#aws_s3_bucket resources values
s3_acl                          = ""
s3_lifecycle_rule_id            = ""
s3_lifecyle_enabled             = true
s3_lifecycle_rule_duration      = null
s3_lifecycle_rule_storage_class = ""

#instance resources values
application_security_group_ingress = [null]
ami                                = ""
key_name                           = ""
instance_type                      = ""
root_blook_device_size             = 8
instance_name                      = ""

#DNS resources
domain_name = ""

