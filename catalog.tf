resource "cortex_catalog" "mlb_seasons" {
  slug                  = "mlb-seasons"
  name                  = "MLB Seasons"
  icon_tag              = "baseball"
  description           = "All MLB seasons managed via Terraform"
  is_draft              = false
  type                  = "RELATIONSHIP_TYPE"
  relationship_type_tag = "mlb"
}
