resource "cortex_catalog_entity" "al_league" {
  tag         = "al-2026"
  name        = "American League 2026"
  description = "American League — MLB 2026 Season"
  type        = "mlb"
  groups      = ["mlb-league-2026"]

  parents = [
    { tag = "mlb-2026" }
  ]

  depends_on = [cortex_catalog_entity.mlb_season]
}

resource "cortex_catalog_entity" "nl_league" {
  tag         = "nl-2026"
  name        = "National League 2026"
  description = "National League — MLB 2026 Season"
  type        = "mlb"
  groups      = ["mlb-league-2026"]

  parents = [
    { tag = "mlb-2026" }
  ]

  depends_on = [cortex_catalog_entity.mlb_season]
}
