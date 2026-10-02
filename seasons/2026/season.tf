resource "cortex_catalog_entity" "mlb_season" {
  tag         = "mlb-2026"
  name        = "MLB 2026"
  description = "Major League Baseball — 2026 Season"
  type        = "mlb"
  groups      = ["mlb-season"]
}
