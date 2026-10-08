resource "cortex_resource_definition" "mlb" {
  type        = "mlb"
  name        = "MLB"
  description = "Major League Baseball entity type. Used for seasons, leagues, divisions, and teams."
  schema = jsonencode({
    type       = "object"
    properties = {}
  })
}

resource "cortex_resource_definition" "mlb_leader" {
  type        = "mlb-leader"
  name        = "MLB Statistical Leader"
  description = "Top 10 leaders for an MLB statistical category in a given season."
  schema = jsonencode({
    type = "object"
    properties = {
      category = { type = "string", description = "Statistical category (HR, RBI, AVG, Wins, ERA, K)" }
      season   = { type = "integer", description = "MLB season year" }
      league   = { type = "string", enum = ["AL", "NL"] }
      leaders = {
        type = "array"
        items = {
          type = "object"
          properties = {
            rank   = { type = "integer" }
            player = { type = "string" }
            team   = { type = "string" }
            value  = { type = "string" }
          }
        }
      }
    }
  })
}
