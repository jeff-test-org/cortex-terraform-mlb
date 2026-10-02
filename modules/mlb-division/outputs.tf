output "division_tag" {
  value = local.division_tag
}

output "team_tags" {
  value = { for slug, team in cortex_catalog_entity.teams : slug => team.tag }
}
