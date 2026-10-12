# 2026 Athletics Coaching Staff — Cortex Team Entity
# Data sourced from MLB Stats API (team ID 133):
#   https://statsapi.mlb.com/api/v1/teams/133?season=2026
#   https://statsapi.mlb.com/api/v1/teams/133/coaches?season=2026
resource "cortex_catalog_entity" "athletics_coaching_staff" {
  tag         = "athletics-coaching-staff-2026"
  name        = "2026 Athletics Coaching Staff"
  description = "Coaching staff for the 2026 Athletics (Sutter Health Park, Sacramento)."
  type        = "team"
  groups      = ["mlb-team-2026"]

  metadata = jsonencode({
    mlb_team_id  = 133
    abbreviation = "ATH"
    venue        = "Sutter Health Park"
    location     = "Sacramento, CA"
    league       = "American League"
    division     = "American League West"
    coaching_staff = [
      { name = "Mark Kotsay",      title = "Manager",                             jersey = "7"  },
      { name = "Darren Bush",      title = "Bench Coach and Director of Hitting", jersey = "51" },
      { name = "Mike Aldrete",     title = "Hitting Coach",                       jersey = "18" },
      { name = "Chris Cron",       title = "Hitting Coach",                       jersey = "41" },
      { name = "Dan Hubbs",        title = "Interim Pitching Coach",              jersey = "71" },
      { name = "Scott Emerson",    title = "Pitching Coach",                      jersey = "14" },
      { name = "Ryan Christenson", title = "First Base Coach",                    jersey = "28" },
      { name = "Bobby Crosby",     title = "Third Base Coach",                    jersey = "8"  },
      { name = "Javy Guerra",      title = "Bullpen Coach",                       jersey = "88" },
      { name = "Ramon Hernandez",  title = "Major League Coach and Interpreter",  jersey = "55" },
      { name = "Marcus Jensen",    title = "Quality Control Coach",               jersey = "72" },
    ]
  })
}
