module "al_east" {
  source     = "../../modules/mlb-division"
  year       = "2026"
  league_tag = cortex_catalog_entity.al_league.tag
  division   = "AL East"
  teams = [
    { slug = "baltimore-orioles", name = "Baltimore Orioles", city = "Baltimore",      ballpark = "Oriole Park at Camden Yards", league = "AL" },
    { slug = "boston-red-sox",    name = "Boston Red Sox",    city = "Boston",         ballpark = "Fenway Park",                 league = "AL" },
    { slug = "new-york-yankees",  name = "New York Yankees",  city = "Bronx",          ballpark = "Yankee Stadium",              league = "AL" },
    { slug = "tampa-bay-rays",    name = "Tampa Bay Rays",    city = "St. Petersburg", ballpark = "Tropicana Field",             league = "AL" },
    { slug = "toronto-blue-jays", name = "Toronto Blue Jays", city = "Toronto",        ballpark = "Rogers Centre",               league = "AL" },
  ]
}

module "al_central" {
  source     = "../../modules/mlb-division"
  year       = "2026"
  league_tag = cortex_catalog_entity.al_league.tag
  division   = "AL Central"
  teams = [
    { slug = "chicago-white-sox",   name = "Chicago White Sox",   city = "Chicago",     ballpark = "Guaranteed Rate Field", league = "AL" },
    { slug = "cleveland-guardians", name = "Cleveland Guardians", city = "Cleveland",   ballpark = "Progressive Field",     league = "AL" },
    { slug = "detroit-tigers",      name = "Detroit Tigers",      city = "Detroit",     ballpark = "Comerica Park",         league = "AL" },
    { slug = "kansas-city-royals",  name = "Kansas City Royals",  city = "Kansas City", ballpark = "Kauffman Stadium",      league = "AL" },
    { slug = "minnesota-twins",     name = "Minnesota Twins",     city = "Minneapolis", ballpark = "Target Field",          league = "AL" },
  ]
}

module "al_west" {
  source     = "../../modules/mlb-division"
  year       = "2026"
  league_tag = cortex_catalog_entity.al_league.tag
  division   = "AL West"
  teams = [
    { slug = "houston-astros",      name = "Houston Astros",      city = "Houston",    ballpark = "Minute Maid Park",   league = "AL" },
    { slug = "los-angeles-angels",  name = "Los Angeles Angels",  city = "Anaheim",    ballpark = "Angel Stadium",      league = "AL" },
    { slug = "las-vegas-athletics", name = "Las Vegas Athletics", city = "Las Vegas",  ballpark = "Las Vegas Ballpark", league = "AL" },
    { slug = "seattle-mariners",    name = "Seattle Mariners",    city = "Seattle",    ballpark = "T-Mobile Park",      league = "AL" },
    { slug = "texas-rangers",       name = "Texas Rangers",       city = "Arlington",  ballpark = "Globe Life Field",   league = "AL" },
  ]
}

module "nl_east" {
  source     = "../../modules/mlb-division"
  year       = "2026"
  league_tag = cortex_catalog_entity.nl_league.tag
  division   = "NL East"
  teams = [
    { slug = "atlanta-braves",        name = "Atlanta Braves",        city = "Atlanta",      ballpark = "Truist Park",        league = "NL" },
    { slug = "miami-marlins",         name = "Miami Marlins",         city = "Miami",        ballpark = "loanDepot park",     league = "NL" },
    { slug = "new-york-mets",         name = "New York Mets",         city = "Flushing",     ballpark = "Citi Field",         league = "NL" },
    { slug = "philadelphia-phillies", name = "Philadelphia Phillies", city = "Philadelphia", ballpark = "Citizens Bank Park", league = "NL" },
    { slug = "washington-nationals",  name = "Washington Nationals",  city = "Washington",   ballpark = "Nationals Park",     league = "NL" },
  ]
}

module "nl_central" {
  source     = "../../modules/mlb-division"
  year       = "2026"
  league_tag = cortex_catalog_entity.nl_league.tag
  division   = "NL Central"
  teams = [
    { slug = "chicago-cubs",       name = "Chicago Cubs",       city = "Chicago",     ballpark = "Wrigley Field",            league = "NL" },
    { slug = "cincinnati-reds",    name = "Cincinnati Reds",    city = "Cincinnati",  ballpark = "Great American Ball Park", league = "NL" },
    { slug = "milwaukee-brewers",  name = "Milwaukee Brewers",  city = "Milwaukee",   ballpark = "American Family Field",    league = "NL" },
    { slug = "pittsburgh-pirates", name = "Pittsburgh Pirates", city = "Pittsburgh",  ballpark = "PNC Park",                 league = "NL" },
    { slug = "st-louis-cardinals", name = "St. Louis Cardinals", city = "St. Louis", ballpark = "Busch Stadium",            league = "NL" },
  ]
}

module "nl_west" {
  source     = "../../modules/mlb-division"
  year       = "2026"
  league_tag = cortex_catalog_entity.nl_league.tag
  division   = "NL West"
  teams = [
    { slug = "arizona-diamondbacks",  name = "Arizona Diamondbacks",  city = "Phoenix",       ballpark = "Chase Field",    league = "NL" },
    { slug = "colorado-rockies",      name = "Colorado Rockies",      city = "Denver",         ballpark = "Coors Field",    league = "NL" },
    { slug = "los-angeles-dodgers",   name = "Los Angeles Dodgers",   city = "Los Angeles",    ballpark = "Dodger Stadium", league = "NL" },
    { slug = "san-diego-padres",      name = "San Diego Padres",      city = "San Diego",      ballpark = "Petco Park",     league = "NL" },
    { slug = "san-francisco-giants",  name = "San Francisco Giants",  city = "San Francisco",  ballpark = "Oracle Park",    league = "NL" },
  ]
}
