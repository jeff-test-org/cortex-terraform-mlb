locals {
  division_tag = "${lower(replace(var.division, " ", "-"))}-${var.year}"
}

resource "cortex_catalog_entity" "division" {
  tag         = local.division_tag
  name        = "${var.division} ${var.year}"
  description = "${var.division} — MLB ${var.year} Season"
  type        = "mlb"
  groups      = ["mlb-division-${var.year}"]

  parents = [
    { tag = var.league_tag }
  ]
}

resource "cortex_catalog_entity" "teams" {
  for_each = { for t in var.teams : t.slug => t }

  tag         = "${each.value.slug}-${var.year}"
  name        = each.value.name
  description = "${each.value.name} — ${var.division} ${var.year}"
  type        = "mlb"
  groups      = ["mlb-team-${var.year}"]

  parents = [
    { tag = local.division_tag }
  ]

  metadata = jsonencode({
    city     = each.value.city
    ballpark = each.value.ballpark
    league   = each.value.league
    division = var.division
    year     = var.year
  })

  depends_on = [cortex_catalog_entity.division]
}
