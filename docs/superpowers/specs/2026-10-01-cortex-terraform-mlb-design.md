# cortex-terraform-mlb Design Spec
**Date:** 2026-10-01
**Status:** Approved for implementation

## Purpose

A Terraform reference project demonstrating how to configure a Cortex.io instance using the `terraform-provider-cortex`. Uses Major League Baseball (MLB) as the domain — all 30 teams organized into a season → league → division hierarchy — to give customers a realistic, relatable example they can learn from and adapt.

Secondary goal: serve as a sandbox for contributing to [terraform-provider-cortex](https://github.com/cortexapps/terraform-provider-cortex).

## Constraints & Decisions

- **GitHub org:** `jeff-test-org`
- **Repo name:** `cortex-terraform-mlb`
- **Cortex tenant:** `jeff-sandbox`
- **Terraform state:** local (`terraform.tfstate`) for v1; GitOps via HCP Terraform (free tier) is the documented upgrade path
- **Data source:** [MLB Stats API](https://statsapi.mlb.com) — public, no auth required, no scraping
- **Entity type:** `mlb` for all entities (season, league, division, team); differentiated by `groups`
- **Provider version:** Published registry (`cortexapps/cortex`); local dev override documented for `feature/catalog-resource` work
- **Players:** Out of scope

## Entity Model

All entities share `type = "mlb"`. Groups distinguish hierarchy level:

| Level | Example tag | groups |
|-------|-------------|--------|
| Season | `mlb-2026` | `["mlb-season"]` |
| League | `al-2026` | `["mlb-league-2026"]` |
| Division | `al-east-2026` | `["mlb-division-2026"]` |
| Team | `boston-red-sox-2026` | `["mlb-team-2026"]` |

**Total entities for 2026:** 1 season + 2 leagues + 6 divisions + 30 teams = **39 entities**

### Domain hierarchy

Cortex domain parents establish the hierarchy:

```
mlb-2026  (season)
├── al-2026  (league, parent: mlb-2026)
│   ├── al-east-2026  (division, parent: al-2026)
│   ├── al-central-2026
│   └── al-west-2026
└── nl-2026  (league, parent: mlb-2026)
    ├── nl-east-2026  (division, parent: nl-2026)
    ├── nl-central-2026
    └── nl-west-2026
```

Teams are `cortex_catalog_entity` resources (not domains) with `domain_parents` pointing to their division.

### Team custom metadata

Each team entity includes:
- `city` — home city
- `ballpark` — stadium name
- `league` — AL or NL
- `division` — e.g., AL East

Sourced from the MLB Stats API at implementation time. No live API calls from Terraform.

## Terraform Resources Used

| Resource | File | Purpose |
|----------|------|---------|
| `cortex_catalog_entity` | `modules/mlb-division/main.tf` | Team entities (30 total) |
| `cortex_catalog_entity` | `seasons/2026/season.tf` | Season entity (mlb-2026) |
| `cortex_catalog_entity` | `seasons/2026/leagues.tf` | League entities (al-2026, nl-2026) |
| `cortex_catalog_entity` | `seasons/2026/divisions.tf` (via module) | Division entities (6 total) |
| `cortex_catalog` | `catalog.tf` | "MLB Seasons" catalog view |

## Repository Structure

```
cortex-terraform-mlb/
  main.tf                        # provider config, local backend
  catalog.tf                     # cortex_catalog "MLB Seasons"
  variables.tf                   # cortex_api_key, cortex_base_url
  outputs.tf
  README.md
  .gitignore                     # excludes terraform.tfstate, .terraform/, *.tfvars
  modules/
    mlb-division/
      main.tf                    # division entity + for_each over var.teams
      variables.tf               # year, division, league_tag, teams list
      outputs.tf                 # division_tag, team_tags
  seasons/
    2026/
      season.tf                  # mlb-2026 entity
      leagues.tf                 # al-2026, nl-2026 entities
      divisions.tf               # 6x module "mlb_division" calls with team data
```

### Key design choices

- `modules/` contains the reusable blueprint — no MLB-specific data, no year hardcoding
- `seasons/YYYY/` contains the data for a specific season; adding 2027 = new directory, same module
- `divisions.tf` is the primary teaching artifact: shows module reuse + for_each in one file
- The `cortex_catalog` resource in `catalog.tf` showcases Jeff's `feature/catalog-resource` provider contribution

## Module: mlb-division

**Input variables:**
```hcl
variable "year"       { type = string }           # "2026"
variable "league_tag" { type = string }           # "al-2026"
variable "division"   { type = string }           # "AL East"
variable "teams" {
  type = list(object({
    name     = string   # "Boston Red Sox"
    city     = string   # "Boston"
    ballpark = string   # "Fenway Park"
    league   = string   # "AL"
  }))
}
```

**Creates:**
1. One `cortex_catalog_entity` for the division (type=mlb, group=mlb-division-YYYY, domain_parent=league_tag)
2. One `cortex_catalog_entity` per team via `for_each` (type=mlb, group=mlb-team-YYYY, domain_parent=division tag)

## Catalog Resource

One `cortex_catalog` resource — "MLB Seasons" — with a filter that includes all entities in the `mlb-season` group. As new seasons are added, they appear automatically.

```hcl
resource "cortex_catalog" "mlb_seasons" {
  slug  = "mlb-seasons"
  name  = "MLB Seasons"
  type  = "FILTER"
  filter {
    query = "tag != null"
    groups { include = ["mlb-season"] }
  }
}
```

## Provider Configuration

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

`cortex_api_key` is passed via environment variable (`TF_VAR_cortex_api_key`) — never committed.

## GitOps Upgrade Path (documented in README)

v1 is manual `terraform apply`. The README documents the path to GitOps:

1. **Local state** (v1) — `terraform apply` from the CLI
2. **HCP Terraform** (free tier) — remote state, plan-on-PR, approval gates
3. **GitHub Actions** — trigger plans on PR, apply on merge to main
4. **Terragrunt** — if directory-per-entity hierarchy is needed at scale

## Assumptions

- The `cortex_catalog` resource is available in the published provider by the time this is wired up (or a local dev override is used)
- `domain_parents` is supported in `cortex_catalog_entity` in the current provider — needs verification at implementation time
- MLB Stats API team/division data is fetched manually and hardcoded as Terraform values (no dynamic provider data source)
