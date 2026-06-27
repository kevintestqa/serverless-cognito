# Table Name: token-tracking
# Partition Key: token_id
# Type:: String
# Capacity Mode: On-demand
# https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.NamingRulesDataTypes.html


resource "aws_dynamodb_table" "satellite_db" {
  name         = "token-trackingv2"
  hash_key     = "token_id"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "token_id"
    type = "S"
  }

  attribute {
    name = "username"
    type = "S"
  }

  attribute {
    name = "used"
    type = "B"
  }

  attribute {
    name = "issued_at"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  global_secondary_index {
    name = "satellite-DB-Index"
    key_schema {
      attribute_name = "username"
      key_type       = "HASH"
    }
    key_schema {
      attribute_name = "used"
      key_type       = "HASH"
    }
    key_schema {
      attribute_name = "issued_at"
      key_type       = "HASH"
    }
    projection_type = "ALL"
  }
}