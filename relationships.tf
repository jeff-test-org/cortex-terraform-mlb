resource "cortex_entity_relationship" "al_2026_leaders" {
  source_entity_tag     = "al-2026"
  relationship_type_tag = "mlb-to-leader"
  destination_entity_tags = [
    "2026-al-leader-hr",
    "2026-al-leader-rbi",
    "2026-al-leader-avg",
    "2026-al-leader-wins",
    "2026-al-leader-era",
    "2026-al-leader-strikeouts",
  ]
  depends_on = [
    cortex_relationship_type.mlb_to_leader,
    cortex_catalog_entity.al_leader_hr,
    cortex_catalog_entity.al_leader_rbi,
    cortex_catalog_entity.al_leader_avg,
    cortex_catalog_entity.al_leader_wins,
    cortex_catalog_entity.al_leader_era,
    cortex_catalog_entity.al_leader_strikeouts,
  ]
}

resource "cortex_entity_relationship" "nl_2026_leaders" {
  source_entity_tag     = "nl-2026"
  relationship_type_tag = "mlb-to-leader"
  destination_entity_tags = [
    "2026-nl-leader-hr",
    "2026-nl-leader-rbi",
    "2026-nl-leader-avg",
    "2026-nl-leader-wins",
    "2026-nl-leader-era",
    "2026-nl-leader-strikeouts",
  ]
  depends_on = [
    cortex_relationship_type.mlb_to_leader,
    cortex_catalog_entity.nl_leader_hr,
    cortex_catalog_entity.nl_leader_rbi,
    cortex_catalog_entity.nl_leader_avg,
    cortex_catalog_entity.nl_leader_wins,
    cortex_catalog_entity.nl_leader_era,
    cortex_catalog_entity.nl_leader_strikeouts,
  ]
}
