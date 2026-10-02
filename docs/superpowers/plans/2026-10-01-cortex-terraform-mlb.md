# cortex-terraform-mlb Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Terraform reference project that creates 39 Cortex entities (1 season, 2 leagues, 6 divisions, 30 teams) in the `jeff-sandbox` tenant, organized as a season → league → division → team hierarchy under a single `mlb` custom type.

**Architecture:** Reusable `modules/mlb-division` module takes a division name + team list and creates one division entity plus one team entity per team via `for_each`. Six module calls in `seasons/2026/divisions.tf` cover all 30 MLB teams. Season and league entities are declared directly in `seasons/2026/`. A `cortex_resource_definition` for the `mlb` type is a prerequisite — without it, all `type = "mlb"` entities are rejected by the API.

**Tech Stack:** Terraform ~> 1.5, `cortexapps/cortex` provider `~> 0.1`, local state backend

**Spec:** `docs/superpowers/specs/2026-10-01-cortex-terraform-mlb-design.md`

## Global Constraints

- All entities: `type = "mlb"` — requires `cortex_resource_definition` with `type = "mlb"` to exist first
- Hierarchy field in provider is `parents` (list of `{ tag = string }`) — NOT `domain_parents`
- `cortex_catalog` resource requires `is_draft` bool field
- Entity tag format: `<slug>-<year>` e.g., `boston-red-sox-2026`, `al-east-2026`
- Groups by level: `mlb-season`, `mlb-league-2026`, `mlb-division-2026`, `mlb-team-2026`
- API key passed via `TF_VAR_cortex_api_key` env var — never committed
- Cortex tenant: `jeff-sandbox` (`https://api.getcortexapp.com`)
- No players, no scorecards, no relationship types in v1

## Review Focus

- **`cortex_catalog` local build:** `cortex_catalog` is not in the published provider. Task 6 requires building `feature/catalog-resource` locally and configuring `~/.terraformrc` with `dev_overrides`. When dev_overrides is active, `terraform init` is skipped for the cortex provider — do not run `terraform init` after adding the override or it will fail. Tasks 1–5 use the published provider; Task 6 switches to the local build.
- **Parent ordering:** Teams reference their division tag via `local.division_tag` within the same module — Terraform resolves this automatically. But leagues reference the season tag as a string literal, not a resource reference — add `depends_on` in `leagues.tf` if apply fails with "parent not found".
- **`type = "mlb"` on domains:** The provider schema notes type must be a Resource Definition tag, `"team"`, or `"domain"`. Season and league entities use `parents` to create hierarchy but should NOT use `type = "domain"` — they use `type = "mlb"`. Verify the API accepts `type = "mlb"` on entities that have `parents` set. If it rejects, use `type = "domain"` for season/league/division only.
- **`for_each` key collisions:** Team slugs must be unique within a division call. They are hardcoded strings — visually verify no duplicates in `divisions.tf` before apply.
- **`cortex_catalog` filter syntax:** The `groups { include = [...] }` block inside `filter` must be confirmed against the actual schema in `catalog_resource.go`. Task 7 includes a `terraform validate` gate before apply.

---

## File Map

| File | Responsibility |
|------|---------------|
| `main.tf` | Provider config, local backend |
| `variables.tf` | `cortex_api_key`, `cortex_base_url` |
| `outputs.tf` | Empty for v1 |
| `.gitignore` | Excludes state, `.terraform/`, `*.tfvars` |
| `README.md` | Setup guide + GitOps upgrade path |
| `resource_definition.tf` | `cortex_resource_definition "mlb"` — prerequisite for all type=mlb entities |
| `catalog.tf` | `cortex_catalog "mlb_seasons"` — filtered view of mlb-season group |
| `modules/mlb-division/variables.tf` | Module inputs: year, division, league_tag, teams list |
| `modules/mlb-division/main.tf` | Division entity + for_each team entities |
| `modules/mlb-division/outputs.tf` | `division_tag`, `team_tags` |
| `seasons/2026/season.tf` | `mlb-2026` entity |
| `seasons/2026/leagues.tf` | `al-2026`, `nl-2026` entities |
| `seasons/2026/divisions.tf` | 6x module calls with all 30 team definitions |

---

## Task 1: Repository scaffolding and provider config

**Files:**
- Create: `main.tf`
- Create: `variables.tf`
- Create: `outputs.tf`
- Create: `.gitignore`
- Create: `README.md` (skeleton — full content in Task 9)

**Interfaces:**
- Produces: initialized Terraform working directory; `var.cortex_api_key` and `var.cortex_base_url` available to all subsequent tasks

- [ ] **Step 1: Initialize git repo**

```bash
cd /Users/jeffschnitter/git/jeff-test-org/cortex-terraform-mlb
git init
```

- [ ] **Step 2: Write `.gitignore`**

```
.terraform/
terraform.tfstate
terraform.tfstate.backup
*.tfvars
.terraform.lock.hcl
```

- [ ] **Step 3: Write `variables.tf`**

```hcl
variable "cortex_api_key" {
  description = "Cortex API key. Pass via TF_VAR_cortex_api_key environment variable."
  type        = string
  sensitive   = true
}

variable "cortex_base_url" {
  description = "Cortex API base URL."
  type        = string
  default     = "https://api.getcortexapp.com"
}
```

- [ ] **Step 4: Write `main.tf`**

```hcl
terraform {
  required_providers {
    cortex = {
      source  = "cortexapps/cortex"
      version = "~> 0.1"
    }
  }
}

provider "cortex" {
  api_key  = var.cortex_api_key
  base_url = var.cortex_base_url
}
```

- [ ] **Step 5: Write `outputs.tf`**

Empty file with a comment: `# Outputs added in future iterations`

- [ ] **Step 6: Write `README.md` skeleton**

Title: `# cortex-terraform-mlb`. Single line: `MLB reference project for Cortex Terraform. Full docs coming in Task 9.`

- [ ] **Step 7: Run `terraform init`**

```bash
export TF_VAR_cortex_api_key=$(cortex -t jeff-sandbox config get api-key 2>/dev/null || echo $CORTEX_API_KEY_JEFF_SANDBOX)
terraform init
```

Expected: "Terraform has been successfully initialized"

- [ ] **Step 8: Commit**

```bash
git add .
git commit -m "feat: scaffold repo with provider config and gitignore"
```

---

## Task 2: MLB resource definition

**Files:**
- Create: `resource_definition.tf`

**Interfaces:**
- Produces: `cortex_resource_definition.mlb` — unlocks `type = "mlb"` on all catalog entities in Tasks 3–8
- Consumes: provider from Task 1

- [ ] **Step 1: Write `resource_definition.tf`**

```hcl
resource "cortex_resource_definition" "mlb" {
  type        = "mlb"
  name        = "MLB"
  description = "Major League Baseball entity type. Used for seasons, leagues, divisions, and teams."
  schema = jsonencode({
    type       = "object"
    properties = {}
  })
}
```

- [ ] **Step 2: Run `terraform validate`**

```bash
terraform validate
```

Expected: "Success! The configuration is valid."

- [ ] **Step 3: Run `terraform plan`**

```bash
terraform plan
```

Expected: `Plan: 1 to add` — the mlb resource definition.

- [ ] **Step 4: Apply**

```bash
terraform apply -auto-approve
```

Expected: `Apply complete! Resources: 1 added.`

- [ ] **Step 5: Verify in Cortex**

```bash
cortex -t jeff-sandbox resource-definitions get --type mlb
```

Expected: resource definition with type `mlb` returned.

- [ ] **Step 6: Commit**

```bash
git add resource_definition.tf terraform.tfstate
git commit -m "feat: add mlb resource definition"
```

---

## Task 3: mlb-division module

**Files:**
- Create: `modules/mlb-division/variables.tf`
- Create: `modules/mlb-division/main.tf`
- Create: `modules/mlb-division/outputs.tf`

**Interfaces:**
- Consumes: `cortex_resource_definition.mlb` (must exist in tenant before apply)
- Produces:
  - Module input: `var.year` (string), `var.division` (string), `var.league_tag` (string), `var.teams` (list of objects)
  - Module output: `output.division_tag` (string), `output.team_tags` (map of string)
  - Each team object: `{ slug: string, name: string, city: string, ballpark: string, league: string }`

- [ ] **Step 1: Write `modules/mlb-division/variables.tf`**

```hcl
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
  }))
}
```

- [ ] **Step 2: Write `modules/mlb-division/main.tf`**

```hcl
locals {
  division_tag = "${lower(replace(var.division, " ", "-"))}-${var.year}"
}

resource "cortex_catalog_entity" "division" {
  tag         = local.division_tag
  name        = "${var.division} ${var.year}"
  description = "${var.division} — MLB ${var.year} Season"
  type        = "mlb"
  groups      = ["mlb-division-${var.year}"]

  parents = [
    { tag = var.league_tag }
  ]
}

resource "cortex_catalog_entity" "teams" {
  for_each = { for t in var.teams : t.slug => t }

  tag         = "${each.value.slug}-${var.year}"
  name        = each.value.name
  description = "${each.value.name} — ${var.division} ${var.year}"
  type        = "mlb"
  groups      = ["mlb-team-${var.year}"]

  parents = [
    { tag = local.division_tag }
  ]

  metadata = jsonencode({
    city     = each.value.city
    ballpark = each.value.ballpark
    league   = each.value.league
    division = var.division
    year     = var.year
  })

  depends_on = [cortex_catalog_entity.division]
}
```

- [ ] **Step 3: Write `modules/mlb-division/outputs.tf`**

```hcl
output "division_tag" {
  value = local.division_tag
}

output "team_tags" {
  value = { for slug, team in cortex_catalog_entity.teams : slug => team.tag }
}
```

- [ ] **Step 4: Run `terraform validate`**

```bash
terraform validate
```

Expected: "Success!" — module is not called yet but must be syntactically valid.

- [ ] **Step 5: Commit**

```bash
git add modules/
git commit -m "feat: add mlb-division reusable module"
```

---

## Task 4: Season 2026 — season and league entities

**Files:**
- Create: `seasons/2026/season.tf`
- Create: `seasons/2026/leagues.tf`

**Interfaces:**
- Consumes: `cortex_resource_definition.mlb` (Task 2)
- Produces: `cortex_catalog_entity.mlb_season` (tag: `mlb-2026`), `cortex_catalog_entity.al_league` (tag: `al-2026`), `cortex_catalog_entity.nl_league` (tag: `nl-2026`) — referenced by module calls in Task 5

- [ ] **Step 1: Write `seasons/2026/season.tf`**

```hcl
resource "cortex_catalog_entity" "mlb_season" {
  tag         = "mlb-2026"
  name        = "MLB 2026"
  description = "Major League Baseball — 2026 Season"
  type        = "mlb"
  groups      = ["mlb-season"]
}
```

- [ ] **Step 2: Write `seasons/2026/leagues.tf`**

```hcl
resource "cortex_catalog_entity" "al_league" {
  tag         = "al-2026"
  name        = "American League 2026"
  description = "American League — MLB 2026 Season"
  type        = "mlb"
  groups      = ["mlb-league-2026"]

  parents = [
    { tag = "mlb-2026" }
  ]

  depends_on = [cortex_catalog_entity.mlb_season]
}

resource "cortex_catalog_entity" "nl_league" {
  tag         = "nl-2026"
  name        = "National League 2026"
  description = "National League — MLB 2026 Season"
  type        = "mlb"
  groups      = ["mlb-league-2026"]

  parents = [
    { tag = "mlb-2026" }
  ]

  depends_on = [cortex_catalog_entity.mlb_season]
}
```

Note: `cortex_catalog_entity.mlb_season` is in a separate file but same Terraform root — the reference is valid.

- [ ] **Step 3: Run `terraform validate`**

```bash
terraform validate
```

Expected: "Success!"

- [ ] **Step 4: Run `terraform plan`**

```bash
terraform plan
```

Expected: `Plan: 3 to add` (mlb-2026, al-2026, nl-2026). Confirm in plan output.

- [ ] **Step 5: Apply**

```bash
terraform apply -auto-approve
```

Expected: `Apply complete! Resources: 3 added.`

- [ ] **Step 6: Verify**

```bash
cortex -t jeff-sandbox catalog get --tag mlb-2026
cortex -t jeff-sandbox catalog get --tag al-2026
cortex -t jeff-sandbox catalog get --tag nl-2026
```

Expected: all three return entities with correct type and groups.

- [ ] **Step 7: Commit**

```bash
git add seasons/ terraform.tfstate
git commit -m "feat: add mlb-2026 season and league entities"
```

---

## Task 5: Season 2026 — all six divisions and 30 teams

**Files:**
- Create: `seasons/2026/divisions.tf`

**Interfaces:**
- Consumes: `module "mlb_division"` from Task 3; league tags `al-2026` and `nl-2026` from Task 4
- Produces: 6 division entities + 30 team entities in jeff-sandbox

Team data sourced directly from the MLB Stats API (`statsapi.get('teams', {'sportId': 1, 'season': 2024})`). Oakland A's updated to Las Vegas Athletics to reflect 2026 relocation.

- [ ] **Step 1: Write `seasons/2026/divisions.tf`**

```hcl
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
```

- [ ] **Step 2: Run `terraform validate`**

```bash
terraform validate
```

Expected: "Success!"

- [ ] **Step 3: Run `terraform plan`**

```bash
terraform plan
```

Expected: `Plan: 36 to add` (6 divisions + 30 teams). Scan output for any unexpected replacements or errors.

- [ ] **Step 4: Apply**

```bash
terraform apply -auto-approve
```

Expected: `Apply complete! Resources: 36 added.`

- [ ] **Step 5: Verify spot-check**

```bash
cortex -t jeff-sandbox catalog get --tag boston-red-sox-2026
cortex -t jeff-sandbox catalog get --tag al-east-2026
cortex -t jeff-sandbox catalog get --tag nl-west-2026
cortex -t jeff-sandbox catalog get --tag los-angeles-dodgers-2026
```

Expected: all four return entities with correct `type: mlb`, correct `groups`, and correct `parents`.

- [ ] **Step 6: Commit**

```bash
git add seasons/2026/divisions.tf terraform.tfstate
git commit -m "feat: add all 6 divisions and 30 MLB team entities for 2026"
```

---

## Task 6: MLB Seasons catalog

**Files:**
- Create: `catalog.tf`
- Modify: `main.tf` (add dev_overrides block)

**Interfaces:**
- Consumes: `mlb-season` group (set on `mlb-2026` entity in Task 4)
- Produces: `cortex_catalog.mlb_seasons` — a filtered catalog view in jeff-sandbox

**Note:** `cortex_catalog` is NOT in the published provider. It is implemented on the `feature/catalog-resource` branch at `/Users/jeffschnitter/git/terraform-provider-cortex`. A local dev override is required. The dev_overrides block replaces version pinning for the cortex provider — `terraform init` is skipped when dev_overrides is active.

- [ ] **Step 1: Build the provider from `feature/catalog-resource`**

```bash
cd /Users/jeffschnitter/git/terraform-provider-cortex
git checkout feature/catalog-resource
go build -o terraform-provider-cortex .
```

Note the full path to the built binary — used in the next step.

- [ ] **Step 2: Create `~/.terraformrc` with dev override**

```hcl
provider_installation {
  dev_overrides {
    "cortexapps/cortex" = "/Users/jeffschnitter/git/terraform-provider-cortex"
  }
  direct {}
}
```

This tells Terraform to load the `cortexapps/cortex` provider from the local build directory instead of the registry. The `direct {}` block allows all other providers to resolve normally.

- [ ] **Step 3: Verify override is active**

```bash
cd /Users/jeffschnitter/git/jeff-test-org/cortex-terraform-mlb
terraform version
```

Expected: output includes a warning like "Provider development overrides are in effect" — this confirms the local build is being used.

- [ ] **Step 4: Write `catalog.tf`**

```hcl
resource "cortex_catalog" "mlb_seasons" {
  slug        = "mlb-seasons"
  name        = "MLB Seasons"
  description = "All MLB seasons managed via Terraform"
  is_draft    = false
  type        = "FILTER"

  filter {
    query = "tag != null"

    groups {
      include = ["mlb-season"]
    }
  }
}
```

- [ ] **Step 3: Run `terraform validate`**

```bash
terraform validate
```

Expected: "Success!" — if this fails with "An argument named 'cortex_catalog' is not expected", the local dev override is required (see prerequisite).

- [ ] **Step 4: Run `terraform plan`**

```bash
terraform plan
```

Expected: `Plan: 1 to add` — the mlb_seasons catalog.

- [ ] **Step 5: Apply**

```bash
terraform apply -auto-approve
```

Expected: `Apply complete! Resources: 1 added.`

- [ ] **Step 6: Verify**

```bash
cortex -t jeff-sandbox catalogs get --slug mlb-seasons
```

Expected: catalog returned with name "MLB Seasons" and filter showing `mlb-season` group.

- [ ] **Step 7: Commit**

```bash
git add catalog.tf terraform.tfstate
git commit -m "feat: add MLB Seasons catalog resource"
```

---

## Task 7: README and GitOps upgrade path documentation

**Files:**
- Modify: `README.md` (replace skeleton from Task 1)

**Interfaces:**
- Consumes: all prior tasks (documents what was built)
- Produces: complete README usable by customers

- [ ] **Step 1: Write complete `README.md`**

Sections to include (prose — implementer writes the content):

1. **Overview** — what this repo is, who it's for, link to `terraform-provider-cortex`
2. **Entity model** — reproduce the table from the spec (Season/League/Division/Team, tags, groups)
3. **Prerequisites** — Terraform >= 1.5, Cortex API key, `cortexapps/cortex` provider
4. **Quick start** — exact commands:
   ```bash
   export TF_VAR_cortex_api_key=<your-key>
   terraform init
   terraform plan
   terraform apply
   ```
5. **Adding a new season** — explain: create `seasons/2027/`, copy and update the three files, reuse the same module. No changes to `modules/`.
6. **GitOps upgrade path** — four-stage ladder:
   - Stage 1: Local (current)
   - Stage 2: HCP Terraform free tier — state backend + plan-on-PR
   - Stage 3: GitHub Actions — `.github/workflows/terraform.yml` trigger on PR/push
   - Stage 4: Terragrunt — for directory-per-entity scale
7. **Contributing** — link to `terraform-provider-cortex`, note the `feature/catalog-resource` branch as an example contribution

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: complete README with setup guide and GitOps upgrade path"
```

---

## Task 8: Full end-to-end verification

**Files:** None created — verification only

- [ ] **Step 1: Count entities in jeff-sandbox**

```bash
cortex -t jeff-sandbox catalog list --type mlb | wc -l
```

Expected: 39 (1 season + 2 leagues + 6 divisions + 30 teams)

- [ ] **Step 2: Verify hierarchy spot-check**

```bash
# Season has no parents
cortex -t jeff-sandbox catalog get --tag mlb-2026

# League parent = season
cortex -t jeff-sandbox catalog get --tag nl-2026

# Division parent = league
cortex -t jeff-sandbox catalog get --tag nl-east-2026

# Team parent = division, has metadata
cortex -t jeff-sandbox catalog get --tag new-york-mets-2026
```

Confirm `parents` field is set correctly at each level and team metadata includes `city`, `ballpark`, `league`, `division`.

- [ ] **Step 3: Verify catalog**

Open `https://app.getcortexapp.com` in jeff-sandbox and confirm "MLB Seasons" catalog shows MLB 2026.

- [ ] **Step 4: Run `terraform plan` — confirm no drift**

```bash
terraform plan
```

Expected: `No changes. Your infrastructure matches the configuration.`

- [ ] **Step 5: Tag the release**

```bash
git tag v0.1.0
git push origin main --tags
```

---
