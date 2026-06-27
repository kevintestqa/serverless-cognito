resource "aws_wafv2_web_acl" "satellite_waf_v2" {
  name        = "satellite_waf_v2"
  description = "Example of a managed rule."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          action_to_use {
            count {}
          }

          name = "SizeRestrictions_QUERYSTRING"
        }

        rule_action_override {
          action_to_use {
            count {}
          }

          name = "NoUserAgent_HEADER"
        }

        scope_down_statement {
          geo_match_statement {
            country_codes = ["US", "NL"]
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "oribital-config"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_rule" "satellite_block" {
  name        = "satellite_block"
  priority    = 0
  web_acl_arn = aws_wafv2_web_acl.satellite_waf_v2.arn
  override_action {
    none {}
  }

  statement {
    managed_rule_group_statement {
      name        = "AWSManagedRulesCommonRuleSet"
      vendor_name = "AWS"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "satellite_block"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_rule" "satellite_cross_site_script" {
  name        = "satellite_cross_site_script"
  priority    = 2
  web_acl_arn = aws_wafv2_web_acl.satellite_waf_v2.arn
  override_action {
    none {}
  }

  statement {
    managed_rule_group_statement {
      name        = "AWSManagedRulesCommonRuleSet"
      vendor_name = "AWS"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "satellite_cross_site_script"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "satellite_waf_association" {
  resource_arn = aws_api_gateway_stage.qa_environment.arn
  web_acl_arn  = aws_wafv2_web_acl.satellite_waf_v2.arn
}