# Temporary import blocks for resources that exist in Cortex but not in TF state.
# Remove after successful apply.

import {
  to = cortex_relationship_type.mlb_to_leader
  id = "mlb-to-leader"
}

import {
  to = cortex_catalog_entity_custom_data.al_leader_hr_stats
  id = "2026-al-leader-hr:stats"
}

import {
  to = cortex_catalog_entity_custom_data.al_leader_rbi_stats
  id = "2026-al-leader-rbi:stats"
}

import {
  to = cortex_catalog_entity_custom_data.al_leader_avg_stats
  id = "2026-al-leader-avg:stats"
}

import {
  to = cortex_catalog_entity_custom_data.al_leader_wins_stats
  id = "2026-al-leader-wins:stats"
}

import {
  to = cortex_catalog_entity_custom_data.al_leader_era_stats
  id = "2026-al-leader-era:stats"
}

import {
  to = cortex_catalog_entity_custom_data.al_leader_strikeouts_stats
  id = "2026-al-leader-strikeouts:stats"
}

import {
  to = cortex_catalog_entity_custom_data.nl_leader_hr_stats
  id = "2026-nl-leader-hr:stats"
}

import {
  to = cortex_catalog_entity_custom_data.nl_leader_rbi_stats
  id = "2026-nl-leader-rbi:stats"
}

import {
  to = cortex_catalog_entity_custom_data.nl_leader_avg_stats
  id = "2026-nl-leader-avg:stats"
}

import {
  to = cortex_catalog_entity_custom_data.nl_leader_wins_stats
  id = "2026-nl-leader-wins:stats"
}

import {
  to = cortex_catalog_entity_custom_data.nl_leader_era_stats
  id = "2026-nl-leader-era:stats"
}

import {
  to = cortex_catalog_entity_custom_data.nl_leader_strikeouts_stats
  id = "2026-nl-leader-strikeouts:stats"
}
