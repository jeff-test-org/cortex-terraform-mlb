variable "year" {
  description = "Season year, e.g. \"2026\""
  type        = string
}

variable "division" {
  description = "Division name, e.g. \"AL East\""
  type        = string
}

variable "league_tag" {
  description = "Tag of the parent league entity, e.g. \"al-2026\""
  type        = string
}

variable "teams" {
  description = "List of teams in this division"
  type = list(object({
    slug     = string
    name     = string
    city     = string
    ballpark = string
    league   = string
    wins     = number
    losses   = number
  }))
}

variable "team_owners" {
  description = "Optional map from team slug to Cortex team tag. Teams in this map will have that team set as owner."
  type        = map(string)
  default     = {}
}
