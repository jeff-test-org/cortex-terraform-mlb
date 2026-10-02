module "al_east" {
  source     = "../../modules/mlb-division"
  year       = "2026"
  league_tag = cortex_catalog_entity.al_league.tag
  division   = "AL East"
  teams = [
    { slug = "baltimore-orioles", name = "Baltimore Orioles", city = "Baltimore",      ballpark = "Oriole Park at Camden Yards", league = "AL", wins = 79, losses = 82 },
    { slug = "boston-red-sox",    name = "Boston Red Sox",    city = "Boston",         ballpark = "Fenway Park",                 league = "AL", wins = 87, losses = 75 },
    { slug = "new-york-yankees",  name = "New York Yankees",  city = "Bronx",          ballpark = "Yankee Stadium",              league = "AL", wins = 93, losses = 68 },
    { slug = "tampa-bay-rays",    name = "Tampa Bay Rays",    city = "St. Petersburg", ballpark = "Tropicana Field",             league = "AL", wins = 98, losses = 64 },
    { slug = "toronto-blue-jays", name = "Toronto Blue Jays", city = "Toronto",        ballpark = "Rogers Centre",               league = "AL", wins = 79, losses = 83 },
  ]
}

module "al_central" {
  source     = "../../modules/mlb-division"
  year       = "2026"
  league_tag = cortex_catalog_entity.al_league.tag
  division   = "AL Central"
  teams = [
    { slug = "chicago-white-sox",   name = "Chicago White Sox",   city = "Chicago",     ballpark = "Guaranteed Rate Field", league = "AL", wins = 84, losses = 78 },
    { slug = "cleveland-guardians", name = "Cleveland Guardians", city = "Cleveland",   ballpark = "Progressive Field",     league = "AL", wins = 85, losses = 77 },
    { slug = "detroit-tigers",      name = "Detroit Tigers",      city = "Detroit",     ballpark = "Comerica Park",         league = "AL", wins = 76, losses = 86 },
    { slug = "kansas-city-royals",  name = "Kansas City Royals",  city = "Kansas City", ballpark = "Kauffman Stadium",      league = "AL", wins = 69, losses = 93 },
    { slug = "minnesota-twins",     name = "Minnesota Twins",     city = "Minneapolis", ballpark = "Target Field",          league = "AL", wins = 77, losses = 85 },
  ]
}

module "al_west" {
  source     = "../../modules/mlb-division"
  year       = "2026"
  league_tag = cortex_catalog_entity.al_league.tag
  division   = "AL West"
  teams = [
    { slug = "houston-astros",      name = "Houston Astros",      city = "Houston",   ballpark = "Minute Maid Park",   league = "AL", wins = 81, losses = 81 },
    { slug = "los-angeles-angels",  name = "Los Angeles Angels",  city = "Anaheim",   ballpark = "Angel Stadium",      league = "AL", wins = 62, losses = 100 },
    { slug = "las-vegas-athletics", name = "Las Vegas Athletics", city = "Las Vegas", ballpark = "Las Vegas Ballpark", league = "AL", wins = 64, losses = 98 },
    { slug = "seattle-mariners",    name = "Seattle Mariners",    city = "Seattle",   ballpark = "T-Mobile Park",      league = "AL", wins = 76, losses = 86 },
    { slug = "texas-rangers",       name = "Texas Rangers",       city = "Arlington", ballpark = "Globe Life Field",   league = "AL", wins = 80, losses = 82 },
  ]
}

module "nl_east" {
  source     = "../../modules/mlb-division"
  year       = "2026"
  league_tag = cortex_catalog_entity.nl_league.tag
  division   = "NL East"
  teams = [
    { slug = "atlanta-braves",        name = "Atlanta Braves",        city = "Atlanta",      ballpark = "Truist Park",        league = "NL", wins = 94, losses = 68 },
    { slug = "miami-marlins",         name = "Miami Marlins",         city = "Miami",        ballpark = "loanDepot park",     league = "NL", wins = 80, losses = 82 },
    { slug = "new-york-mets",         name = "New York Mets",         city = "Flushing",     ballpark = "Citi Field",         league = "NL", wins = 74, losses = 88 },
    { slug = "philadelphia-phillies", name = "Philadelphia Phillies", city = "Philadelphia", ballpark = "Citizens Bank Park", league = "NL", wins = 88, losses = 74 },
    { slug = "washington-nationals",  name = "Washington Nationals",  city = "Washington",   ballpark = "Nationals Park",     league = "NL", wins = 77, losses = 85 },
  ]
}

module "nl_central" {
  source     = "../../modules/mlb-division"
  year       = "2026"
  league_tag = cortex_catalog_entity.nl_league.tag
  division   = "NL Central"
  teams = [
    { slug = "chicago-cubs",       name = "Chicago Cubs",        city = "Chicago",    ballpark = "Wrigley Field",            league = "NL", wins = 89, losses = 73 },
    { slug = "cincinnati-reds",    name = "Cincinnati Reds",     city = "Cincinnati", ballpark = "Great American Ball Park", league = "NL", wins = 75, losses = 87 },
    { slug = "milwaukee-brewers",  name = "Milwaukee Brewers",   city = "Milwaukee",  ballpark = "American Family Field",    league = "NL", wins = 103, losses = 59 },
    { slug = "pittsburgh-pirates", name = "Pittsburgh Pirates",  city = "Pittsburgh", ballpark = "PNC Park",                 league = "NL", wins = 82, losses = 80 },
    { slug = "st-louis-cardinals", name = "St. Louis Cardinals", city = "St. Louis",  ballpark = "Busch Stadium",            league = "NL", wins = 77, losses = 85 },
  ]
}

module "nl_west" {
  source     = "../../modules/mlb-division"
  year       = "2026"
  league_tag = cortex_catalog_entity.nl_league.tag
  division   = "NL West"
  teams = [
    { slug = "arizona-diamondbacks",  name = "Arizona Diamondbacks",  city = "Phoenix",       ballpark = "Chase Field",    league = "NL", wins = 86, losses = 76 },
    { slug = "colorado-rockies",      name = "Colorado Rockies",      city = "Denver",         ballpark = "Coors Field",    league = "NL", wins = 58, losses = 104 },
    { slug = "los-angeles-dodgers",   name = "Los Angeles Dodgers",   city = "Los Angeles",    ballpark = "Dodger Stadium", league = "NL", wins = 100, losses = 62 },
    { slug = "san-diego-padres",      name = "San Diego Padres",      city = "San Diego",      ballpark = "Petco Park",     league = "NL", wins = 91, losses = 71 },
    { slug = "san-francisco-giants",  name = "San Francisco Giants",  city = "San Francisco",  ballpark = "Oracle Park",    league = "NL", wins = 65, losses = 97 },
  ]
}
