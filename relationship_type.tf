resource "cortex_relationship_type" "mlb_to_leader" {
  tag                   = "mlb-to-leader"
  name                  = "Leaders"
  description           = "Links an MLB season entity to its statistical leader boards."
  allow_cycles          = false
  is_single_source      = false
  is_single_destination = false
  definition_location   = "SOURCE"

  sources_filter = {
    include = true
    types   = ["mlb"]
  }

  destinations_filter = {
    include = true
    types   = ["mlb-leader"]
  }

  inheritances = []

  depends_on = [cortex_resource_definition.mlb_leader]
}
