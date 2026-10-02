resource "cortex_resource_definition" "mlb" {
  type        = "mlb"
  name        = "MLB"
  description = "Major League Baseball entity type. Used for seasons, leagues, divisions, and teams."
  schema = jsonencode({
    type       = "object"
    properties = {}
  })
}
