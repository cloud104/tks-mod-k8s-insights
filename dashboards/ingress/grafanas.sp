locals {
  grafanas_common_tags = {
    service = "TKS/Grafanas"
  }
}

category "grafanas" {
  title = "Grafanas"
  color = local.ingress_color
  href  = "/kubernetes_insights.dashboard.grafana_detail?input.grafana_uid={{.properties.'UID' | @uri}}"
  icon  = "format_shapes"
}

query "grafanas_count" {
  sql = <<-EOQ
    select
      count(*) as "Grafanas"
    from
      kubernetes_ingress,
      jsonb_array_elements(rules) as rule,
      jsonb_array_elements(rule->'http'->'paths') as path
    where
      rule->>'host' like 'grafana.%'
  EOQ
}
