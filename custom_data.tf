resource "cortex_catalog_entity_custom_data" "al_leader_hr_stats" {
  tag   = "2026-al-leader-hr"
  key   = "stats"
  value = jsonencode({
    category = "HR"
    season   = 2026
    league   = "AL"
    leaders = [
      { rank = 1, player = "Pete Alonso", team = "Baltimore Orioles", value = "43" },
      { rank = 2, player = "Yordan Alvarez", team = "Houston Astros", value = "42" },
      { rank = 2, player = "Junior Caminero", team = "Tampa Bay Rays", value = "42" },
      { rank = 4, player = "Ben Rice", team = "New York Yankees", value = "41" },
      { rank = 5, player = "Munetaka Murakami", team = "Chicago White Sox", value = "35" },
      { rank = 6, player = "Kazuma Okamoto", team = "Toronto Blue Jays", value = "33" },
      { rank = 6, player = "Miguel Vargas", team = "Chicago White Sox", value = "33" },
      { rank = 8, player = "Colson Montgomery", team = "Chicago White Sox", value = "31" },
      { rank = 9, player = "Christian Walker", team = "Houston Astros", value = "29" },
      { rank = 10, player = "Jake Burger", team = "Texas Rangers", value = "28" },
    ]
  })

  depends_on = [cortex_catalog_entity.al_leader_hr]
}

resource "cortex_catalog_entity_custom_data" "al_leader_rbi_stats" {
  tag   = "2026-al-leader-rbi"
  key   = "stats"
  value = jsonencode({
    category = "RBI"
    season   = 2026
    league   = "AL"
    leaders = [
      { rank = 1, player = "Pete Alonso", team = "Baltimore Orioles", value = "113" },
      { rank = 2, player = "Yordan Alvarez", team = "Houston Astros", value = "106" },
      { rank = 3, player = "Junior Caminero", team = "Tampa Bay Rays", value = "101" },
      { rank = 4, player = "Ben Rice", team = "New York Yankees", value = "97" },
      { rank = 5, player = "Josh Bell", team = "Minnesota Twins", value = "96" },
      { rank = 6, player = "Jo Adell", team = "Cleveland Guardians", value = "94" },
      { rank = 6, player = "Isaac Paredes", team = "Houston Astros", value = "94" },
      { rank = 8, player = "Miguel Vargas", team = "Chicago White Sox", value = "93" },
      { rank = 9, player = "Jonathan Aranda", team = "Tampa Bay Rays", value = "92" },
      { rank = 9, player = "Kazuma Okamoto", team = "Toronto Blue Jays", value = "92" },
    ]
  })

  depends_on = [cortex_catalog_entity.al_leader_rbi]
}

resource "cortex_catalog_entity_custom_data" "al_leader_avg_stats" {
  tag   = "2026-al-leader-avg"
  key   = "stats"
  value = jsonencode({
    category = "AVG"
    season   = 2026
    league   = "AL"
    leaders = [
      { rank = 1, player = "Michael Arroyo", team = "Seattle Mariners", value = ".371" },
      { rank = 2, player = "Joshua Kuroda-Grauer", team = "Athletics", value = ".366" },
      { rank = 3, player = "Gustavo Campero", team = "Los Angeles Angels", value = ".364" },
      { rank = 4, player = "Michael Stefanic", team = "Athletics", value = ".346" },
      { rank = 5, player = "Eduardo Valencia", team = "Detroit Tigers", value = ".341" },
      { rank = 6, player = "Omar Martinez", team = "Los Angeles Angels", value = ".333" },
      { rank = 7, player = "Brett Bateman", team = "Toronto Blue Jays", value = ".329" },
      { rank = 8, player = "Yordan Alvarez", team = "Houston Astros", value = ".316" },
      { rank = 9, player = "Trey Mancini", team = "Los Angeles Angels", value = ".308" },
      { rank = 10, player = "Chandler Simpson", team = "Tampa Bay Rays", value = ".306" },
    ]
  })

  depends_on = [cortex_catalog_entity.al_leader_avg]
}

resource "cortex_catalog_entity_custom_data" "al_leader_wins_stats" {
  tag   = "2026-al-leader-wins"
  key   = "stats"
  value = jsonencode({
    category = "W"
    season   = 2026
    league   = "AL"
    leaders = [
      { rank = 1, player = "Sonny Gray", team = "Boston Red Sox", value = "18" },
      { rank = 2, player = "Drew Rasmussen", team = "Tampa Bay Rays", value = "16" },
      { rank = 3, player = "Nick Martinez", team = "Tampa Bay Rays", value = "15" },
      { rank = 4, player = "Cam Schlittler", team = "New York Yankees", value = "14" },
      { rank = 4, player = "Gavin Williams", team = "Cleveland Guardians", value = "14" },
      { rank = 6, player = "Taj Bradley", team = "Minnesota Twins", value = "12" },
      { rank = 6, player = "Logan Gilbert", team = "Seattle Mariners", value = "12" },
      { rank = 6, player = "Parker Messick", team = "Cleveland Guardians", value = "12" },
      { rank = 6, player = "Jose Soriano", team = "Toronto Blue Jays", value = "12" },
      { rank = 6, player = "Bryan Woo", team = "Seattle Mariners", value = "12" },
    ]
  })

  depends_on = [cortex_catalog_entity.al_leader_wins]
}

resource "cortex_catalog_entity_custom_data" "al_leader_era_stats" {
  tag   = "2026-al-leader-era"
  key   = "stats"
  value = jsonencode({
    category = "ERA"
    season   = 2026
    league   = "AL"
    leaders = [
      { rank = 1, player = "Cam Schlittler", team = "New York Yankees", value = "1.95" },
      { rank = 2, player = "Dylan Cease", team = "Toronto Blue Jays", value = "2.40" },
      { rank = 3, player = "Parker Messick", team = "Cleveland Guardians", value = "2.56" },
      { rank = 4, player = "Drew Rasmussen", team = "Tampa Bay Rays", value = "2.67" },
      { rank = 5, player = "Sonny Gray", team = "Boston Red Sox", value = "2.72" },
      { rank = 6, player = "Nick Martinez", team = "Tampa Bay Rays", value = "3.10" },
      { rank = 7, player = "Michael Wacha", team = "Kansas City Royals", value = "3.32" },
      { rank = 8, player = "Sean Burke", team = "Chicago White Sox", value = "3.34" },
      { rank = 9, player = "Reid Detmers", team = "Los Angeles Angels", value = "3.36" },
      { rank = 10, player = "Logan Gilbert", team = "Seattle Mariners", value = "3.73" },
    ]
  })

  depends_on = [cortex_catalog_entity.al_leader_era]
}

resource "cortex_catalog_entity_custom_data" "al_leader_strikeouts_stats" {
  tag   = "2026-al-leader-strikeouts"
  key   = "stats"
  value = jsonencode({
    category = "K"
    season   = 2026
    league   = "AL"
    leaders = [
      { rank = 1, player = "Gavin Williams", team = "Cleveland Guardians", value = "248" },
      { rank = 2, player = "Dylan Cease", team = "Toronto Blue Jays", value = "239" },
      { rank = 2, player = "Cam Schlittler", team = "New York Yankees", value = "239" },
      { rank = 4, player = "Reid Detmers", team = "Los Angeles Angels", value = "211" },
      { rank = 5, player = "Taj Bradley", team = "Minnesota Twins", value = "205" },
      { rank = 5, player = "Logan Gilbert", team = "Seattle Mariners", value = "205" },
      { rank = 7, player = "Jacob deGrom", team = "Texas Rangers", value = "201" },
      { rank = 8, player = "Parker Messick", team = "Cleveland Guardians", value = "193" },
      { rank = 9, player = "Sean Burke", team = "Chicago White Sox", value = "185" },
      { rank = 10, player = "Bryan Woo", team = "Seattle Mariners", value = "175" },
    ]
  })

  depends_on = [cortex_catalog_entity.al_leader_strikeouts]
}

resource "cortex_catalog_entity_custom_data" "nl_leader_hr_stats" {
  tag   = "2026-nl-leader-hr"
  key   = "stats"
  value = jsonencode({
    category = "HR"
    season   = 2026
    league   = "NL"
    leaders = [
      { rank = 1, player = "Pete Crow-Armstrong", team = "Chicago Cubs", value = "45" },
      { rank = 1, player = "Kyle Schwarber", team = "Philadelphia Phillies", value = "45" },
      { rank = 3, player = "Hunter Goodman", team = "Colorado Rockies", value = "41" },
      { rank = 3, player = "Matt Olson", team = "Atlanta Braves", value = "41" },
      { rank = 5, player = "Rafael Devers", team = "San Francisco Giants", value = "37" },
      { rank = 6, player = "Brandon Lowe", team = "Pittsburgh Pirates", value = "35" },
      { rank = 7, player = "CJ Abrams", team = "Washington Nationals", value = "33" },
      { rank = 8, player = "Sal Stewart", team = "Cincinnati Reds", value = "32" },
      { rank = 9, player = "Nolan Arenado", team = "Arizona Diamondbacks", value = "30" },
      { rank = 9, player = "Elly De La Cruz", team = "Cincinnati Reds", value = "30" },
    ]
  })

  depends_on = [cortex_catalog_entity.nl_leader_hr]
}

resource "cortex_catalog_entity_custom_data" "nl_leader_rbi_stats" {
  tag   = "2026-nl-leader-rbi"
  key   = "stats"
  value = jsonencode({
    category = "RBI"
    season   = 2026
    league   = "NL"
    leaders = [
      { rank = 1, player = "Alec Burleson", team = "St. Louis Cardinals", value = "116" },
      { rank = 2, player = "Sal Stewart", team = "Cincinnati Reds", value = "112" },
      { rank = 3, player = "Pete Crow-Armstrong", team = "Chicago Cubs", value = "107" },
      { rank = 4, player = "CJ Abrams", team = "Washington Nationals", value = "106" },
      { rank = 5, player = "Jordan Walker", team = "St. Louis Cardinals", value = "102" },
      { rank = 6, player = "Brice Turang", team = "Milwaukee Brewers", value = "100" },
      { rank = 7, player = "Rafael Devers", team = "San Francisco Giants", value = "98" },
      { rank = 8, player = "Kyle Schwarber", team = "Philadelphia Phillies", value = "97" },
      { rank = 9, player = "Brandon Lowe", team = "Pittsburgh Pirates", value = "96" },
      { rank = 10, player = "William Contreras", team = "Milwaukee Brewers", value = "94" },
    ]
  })

  depends_on = [cortex_catalog_entity.nl_leader_rbi]
}

resource "cortex_catalog_entity_custom_data" "nl_leader_avg_stats" {
  tag   = "2026-nl-leader-avg"
  key   = "stats"
  value = jsonencode({
    category = "AVG"
    season   = 2026
    league   = "NL"
    leaders = [
      { rank = 1, player = "Gabriel Moreno", team = "Arizona Diamondbacks", value = ".311" },
      { rank = 2, player = "Luis Arraez", team = "Philadelphia Phillies", value = ".310" },
      { rank = 3, player = "Otto Lopez", team = "Miami Marlins", value = ".305" },
      { rank = 4, player = "Nick Gonzales", team = "Pittsburgh Pirates", value = ".303" },
      { rank = 5, player = "TJ Rumfield", team = "Colorado Rockies", value = ".300" },
      { rank = 6, player = "Michael Harris II", team = "Atlanta Braves", value = ".294" },
      { rank = 7, player = "Jackson Chourio", team = "Milwaukee Brewers", value = ".291" },
      { rank = 8, player = "Jake McCarthy", team = "Colorado Rockies", value = ".291" },
      { rank = 9, player = "Fernando Tatis Jr.", team = "San Diego Padres", value = ".289" },
      { rank = 10, player = "Freddie Freeman", team = "Los Angeles Dodgers", value = ".288" },
    ]
  })

  depends_on = [cortex_catalog_entity.nl_leader_avg]
}

resource "cortex_catalog_entity_custom_data" "nl_leader_wins_stats" {
  tag   = "2026-nl-leader-wins"
  key   = "stats"
  value = jsonencode({
    category = "W"
    season   = 2026
    league   = "NL"
    leaders = [
      { rank = 1, player = "Cristopher Sanchez", team = "Philadelphia Phillies", value = "18" },
      { rank = 2, player = "Jacob Misiorowski", team = "Milwaukee Brewers", value = "16" },
      { rank = 2, player = "Eduardo Rodriguez", team = "Arizona Diamondbacks", value = "16" },
      { rank = 4, player = "Chase Burns", team = "Cincinnati Reds", value = "15" },
      { rank = 5, player = "Braxton Ashcraft", team = "Pittsburgh Pirates", value = "14" },
      { rank = 5, player = "Jesus Luzardo", team = "Philadelphia Phillies", value = "14" },
      { rank = 5, player = "Chris Sale", team = "Atlanta Braves", value = "14" },
      { rank = 5, player = "Zack Wheeler", team = "Philadelphia Phillies", value = "14" },
      { rank = 5, player = "Yoshinobu Yamamoto", team = "Los Angeles Dodgers", value = "14" },
      { rank = 10, player = "Sandy Alcantara", team = "Miami Marlins", value = "13" },
    ]
  })

  depends_on = [cortex_catalog_entity.nl_leader_wins]
}

resource "cortex_catalog_entity_custom_data" "nl_leader_era_stats" {
  tag   = "2026-nl-leader-era"
  key   = "stats"
  value = jsonencode({
    category = "ERA"
    season   = 2026
    league   = "NL"
    leaders = [
      { rank = 1, player = "Jacob Misiorowski", team = "Milwaukee Brewers", value = "1.80" },
      { rank = 2, player = "Chris Sale", team = "Atlanta Braves", value = "2.16" },
      { rank = 3, player = "Yoshinobu Yamamoto", team = "Los Angeles Dodgers", value = "2.53" },
      { rank = 4, player = "Jesus Luzardo", team = "Philadelphia Phillies", value = "2.86" },
      { rank = 5, player = "Eduardo Rodriguez", team = "Arizona Diamondbacks", value = "2.89" },
      { rank = 6, player = "Cristopher Sanchez", team = "Philadelphia Phillies", value = "2.91" },
      { rank = 7, player = "Zack Wheeler", team = "Philadelphia Phillies", value = "3.00" },
      { rank = 8, player = "Cade Cavalli", team = "Washington Nationals", value = "3.02" },
      { rank = 9, player = "Nolan McLean", team = "New York Mets", value = "3.16" },
      { rank = 10, player = "Michael King", team = "San Diego Padres", value = "3.21" },
    ]
  })

  depends_on = [cortex_catalog_entity.nl_leader_era]
}

resource "cortex_catalog_entity_custom_data" "nl_leader_strikeouts_stats" {
  tag   = "2026-nl-leader-strikeouts"
  key   = "stats"
  value = jsonencode({
    category = "K"
    season   = 2026
    league   = "NL"
    leaders = [
      { rank = 1, player = "Jacob Misiorowski", team = "Milwaukee Brewers", value = "252" },
      { rank = 2, player = "Cristopher Sanchez", team = "Philadelphia Phillies", value = "231" },
      { rank = 3, player = "Jesus Luzardo", team = "Philadelphia Phillies", value = "221" },
      { rank = 4, player = "Cade Cavalli", team = "Washington Nationals", value = "200" },
      { rank = 4, player = "Chris Sale", team = "Atlanta Braves", value = "200" },
      { rank = 4, player = "Paul Skenes", team = "Pittsburgh Pirates", value = "200" },
      { rank = 7, player = "Nolan McLean", team = "New York Mets", value = "194" },
      { rank = 8, player = "Zack Wheeler", team = "Philadelphia Phillies", value = "193" },
      { rank = 9, player = "Chase Burns", team = "Cincinnati Reds", value = "185" },
      { rank = 10, player = "Yoshinobu Yamamoto", team = "Los Angeles Dodgers", value = "182" },
    ]
  })

  depends_on = [cortex_catalog_entity.nl_leader_strikeouts]
}
