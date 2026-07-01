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
    projection_type = "ALL"
  }
}

# Table 2 WAF Events
# schemaless for non-key fields to store written by lambda (waf_bedrock_analyzer_py):
# event_id, timestamp, source_ip, country, uri, method, action, rule
resource "aws_dynamodb_table" "dynamoDb_waf_events" {
  name         = "waf-events"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "event_id"
  attribute {
    name = "event_id"
    type = "S"
  }
  server_side_encryption {
    enabled = true
  }
  tags = {
    Name      = "waf-events"
    Component = "waf"
  }


}