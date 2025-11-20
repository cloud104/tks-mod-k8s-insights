locals {
  registries_common_tags = {
    service = "TKS/Registries"
  }
}

dashboard "tks_registries" {

    title = "TKS Registries"
    documentation = file("./dashboards/registries/docs/registries.md")

    tags = merge(local.registries_common_tags, {
        type = "Report"
        category = "TKS"        
    })

    container{
    }

    table {
        query = query.registries
    }
}


query "registries" {
    sql = <<-EOQ
      with pod_images as (
        select
          jsonb_array_elements(containers)->>'image' as image
        from
          kubernetes_pod
      ),
      registry_urls as (
        select
          distinct split_part(image, '/', 1) as registry_url
        from
          pod_images
      )
      select
        registry_url
      from
        registry_urls
      where
        registry_url not like '%/%'
        and registry_url not in ('', 'docker.io');
    EOQ
}