resource "cortex_catalog_entity" "al_leader_hr" {
  tag         = "2026-al-leader-hr"
  name        = "2026 AL Home Run Leaders"
  description = "American League home run statistical leaders — MLB 2026 Season"
  type        = "mlb-leader"
  groups      = ["mlb-leader-2026"]

  depends_on = [cortex_resource_definition.mlb_leader]
}

resource "cortex_catalog_entity" "al_leader_rbi" {
  tag         = "2026-al-leader-rbi"
  name        = "2026 AL RBI Leaders"
  description = "American League RBI statistical leaders — MLB 2026 Season"
  type        = "mlb-leader"
  groups      = ["mlb-leader-2026"]

  depends_on = [cortex_resource_definition.mlb_leader]
}

resource "cortex_catalog_entity" "al_leader_avg" {
  tag         = "2026-al-leader-avg"
  name        = "2026 AL Batting Average Leaders"
  description = "American League batting average statistical leaders — MLB 2026 Season"
  type        = "mlb-leader"
  groups      = ["mlb-leader-2026"]

  depends_on = [cortex_resource_definition.mlb_leader]
}

resource "cortex_catalog_entity" "al_leader_wins" {
  tag         = "2026-al-leader-wins"
  name        = "2026 AL Win Leaders"
  description = "American League pitching win statistical leaders — MLB 2026 Season"
  type        = "mlb-leader"
  groups      = ["mlb-leader-2026"]

  depends_on = [cortex_resource_definition.mlb_leader]
}

resource "cortex_catalog_entity" "al_leader_era" {
  tag         = "2026-al-leader-era"
  name        = "2026 AL ERA Leaders"
  description = "American League ERA statistical leaders — MLB 2026 Season"
  type        = "mlb-leader"
  groups      = ["mlb-leader-2026"]

  depends_on = [cortex_resource_definition.mlb_leader]
}

resource "cortex_catalog_entity" "al_leader_strikeouts" {
  tag         = "2026-al-leader-strikeouts"
  name        = "2026 AL Strikeout Leaders"
  description = "American League strikeout statistical leaders — MLB 2026 Season"
  type        = "mlb-leader"
  groups      = ["mlb-leader-2026"]

  depends_on = [cortex_resource_definition.mlb_leader]
}

resource "cortex_catalog_entity" "nl_leader_hr" {
  tag         = "2026-nl-leader-hr"
  name        = "2026 NL Home Run Leaders"
  description = "National League home run statistical leaders — MLB 2026 Season"
  type        = "mlb-leader"
  groups      = ["mlb-leader-2026"]

  depends_on = [cortex_resource_definition.mlb_leader]
}

resource "cortex_catalog_entity" "nl_leader_rbi" {
  tag         = "2026-nl-leader-rbi"
  name        = "2026 NL RBI Leaders"
  description = "National League RBI statistical leaders — MLB 2026 Season"
  type        = "mlb-leader"
  groups      = ["mlb-leader-2026"]

  depends_on = [cortex_resource_definition.mlb_leader]
}

resource "cortex_catalog_entity" "nl_leader_avg" {
  tag         = "2026-nl-leader-avg"
  name        = "2026 NL Batting Average Leaders"
  description = "National League batting average statistical leaders — MLB 2026 Season"
  type        = "mlb-leader"
  groups      = ["mlb-leader-2026"]

  depends_on = [cortex_resource_definition.mlb_leader]
}

resource "cortex_catalog_entity" "nl_leader_wins" {
  tag         = "2026-nl-leader-wins"
  name        = "2026 NL Win Leaders"
  description = "National League pitching win statistical leaders — MLB 2026 Season"
  type        = "mlb-leader"
  groups      = ["mlb-leader-2026"]

  depends_on = [cortex_resource_definition.mlb_leader]
}

resource "cortex_catalog_entity" "nl_leader_era" {
  tag         = "2026-nl-leader-era"
  name        = "2026 NL ERA Leaders"
  description = "National League ERA statistical leaders — MLB 2026 Season"
  type        = "mlb-leader"
  groups      = ["mlb-leader-2026"]

  depends_on = [cortex_resource_definition.mlb_leader]
}

resource "cortex_catalog_entity" "nl_leader_strikeouts" {
  tag         = "2026-nl-leader-strikeouts"
  name        = "2026 NL Strikeout Leaders"
  description = "National League strikeout statistical leaders — MLB 2026 Season"
  type        = "mlb-leader"
  groups      = ["mlb-leader-2026"]

  depends_on = [cortex_resource_definition.mlb_leader]
}
