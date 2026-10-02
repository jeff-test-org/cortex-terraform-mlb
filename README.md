# cortex-terraform-mlb

A comprehensive Terraform reference project demonstrating how to manage the Cortex catalog using Infrastructure as Code (IaC). This repository uses the [cortexapps/cortex Terraform provider](https://registry.terraform.io/providers/cortexapps/cortex/latest/docs) to define and provision a multi-tier MLB entity hierarchy: seasons, leagues, divisions, and teams.

**Who is this for?** Organizations looking to:
- Manage Cortex entities via Terraform instead of manual UI operations
- Understand IaC patterns for multi-level entity hierarchies
- Scale from local development through HCP Terraform to Terragrunt
- Document and version-control their software catalog

**Project Status:** This repository demonstrates Cortex Terraform best practices using real-world MLB data as an example domain.

---

## Entity Model

This project defines a four-level hierarchy of MLB entities, each assigned a `type = "mlb"` via the custom resource definition. The structure demonstrates parent-child relationships, grouping, and metadata storage:

| Entity Type | Example Tag | Name | Description | Groups | Parents | Metadata |
|---|---|---|---|---|---|---|
| **Season** | `mlb-2026` | MLB 2026 | Major League Baseball — 2026 Season | `["mlb-season"]` | None | N/A |
| **League** | `al-2026`, `nl-2026` | American League 2026 | American League — MLB 2026 Season | `["mlb-league-2026"]` | Season | N/A |
| **Division** | `al-east-2026` | AL East 2026 | AL East — MLB 2026 Season | `["mlb-division-2026"]` | League | N/A |
| **Team** | `nyy-2026` | New York Yankees | New York Yankees — AL East 2026 | `["mlb-team-2026"]` | Division | `city`, `ballpark`, `league`, `division`, `year` |

**Example entity hierarchy:**
```
mlb-2026 (Season)
├── al-2026 (League)
│   ├── al-east-2026 (Division)
│   │   ├── nyy-2026 (Team: New York Yankees)
│   │   ├── bos-2026 (Team: Boston Red Sox)
│   │   └── ... (3 more AL East teams)
│   ├── al-central-2026 (Division)
│   └── al-west-2026 (Division)
└── nl-2026 (League)
    ├── nl-east-2026 (Division)
    ├── nl-central-2026 (Division)
    └── nl-west-2026 (Division)
```

**Current state:** 39 entities total (1 season + 2 leagues + 6 divisions + 30 teams) in the Cortex `jeff-sandbox` workspace.

---

## Prerequisites

Before applying this Terraform project, ensure you have:

1. **Terraform >= 1.5** — [Download](https://www.terraform.io/downloads.html)
2. **cortexapps/cortex provider** — automatically downloaded during `terraform init`
   - Current version constraint: `~> 0.1`
   - GitHub: [terraform-provider-cortex](https://github.com/cortexapps/terraform-provider-cortex)
3. **Cortex API key** — obtain from your Cortex workspace
4. **Cortex CLI** (optional but recommended) — for importing pre-existing entities into Terraform state

### Getting Your Cortex API Key

If your API key is stored in the standard Cortex CLI config location (`~/.cortex/config`):

```bash
grep -A3 "\[jeff-sandbox\]" ~/.cortex/config | grep api_key | awk '{print $3}'
```

Alternatively, retrieve it from your Cortex workspace settings.

---

## Quick Start

### 1. Initialize Terraform and Export API Key

```bash
# Export your Cortex API key as an environment variable
export TF_VAR_cortex_api_key=$(grep -A3 "\[jeff-sandbox\]" ~/.cortex/config | grep api_key | awk '{print $3}')

# Initialize Terraform (downloads provider plugins)
terraform init
```

### 2. Review the Execution Plan

```bash
terraform plan
```

### 3. Apply the Configuration

```bash
terraform apply
```

When prompted, review the plan and type `yes` to confirm.

### Example Output

After `terraform apply`:
- 1 custom resource definition (`mlb`)
- 1 catalog (`mlb-seasons`)
- 1 season entity (`mlb-2026`)
- 2 league entities (`al-2026`, `nl-2026`)
- 6 division entities (e.g., `al-east-2026`)
- 30 team entities (e.g., `nyy-2026`)

All entities will appear in your Cortex workspace under the "MLB Seasons" catalog.

---

## Known Issues & Workarounds

### Issue: Custom-Type Entities Cannot Be Created via `terraform apply`

**Status:** Bug in cortexapps/cortex provider v0.11.0

**Symptom:** When running `terraform apply` with entities that have a custom type (e.g., `type = "mlb"`), the apply fails with an error indicating the type is not recognized.

**Root Cause:** The provider's entity creation endpoint does not properly handle custom resource types at creation time.

**Workaround:**

1. Create entities via the Cortex CLI:
   ```bash
   cortex -w jeff-sandbox create entity <entity.yaml>
   ```

2. Import the created entity into Terraform state:
   ```bash
   terraform import cortex_catalog_entity.team_name <entity-tag>
   ```

3. Continue managing the entity via Terraform for future updates.

**Status:** This is a known limitation in v0.11.0. Check the [terraform-provider-cortex issues](https://github.com/cortexapps/terraform-provider-cortex/issues) for updates or contribute a fix.

### Issue: Catalog Resource Requires Feature Branch

**Status:** `cortex_catalog` resource requires provider build from `feature/catalog-resource` branch

**Workaround:**

1. Clone the provider repository:
   ```bash
   git clone https://github.com/cortexapps/terraform-provider-cortex.git
   cd terraform-provider-cortex
   git checkout feature/catalog-resource
   ```

2. Build the provider locally:
   ```bash
   make build
   ```

3. Configure `~/.terraformrc` to use the dev build:
   ```hcl
   dev_overrides {
     "cortexapps/cortex" = "/path/to/terraform-provider-cortex/bin"
   }
   ```

4. Run `terraform init` and `terraform plan` as usual.

---

## Project Structure

```
cortex-terraform-mlb/
├── main.tf                          # Provider configuration
├── variables.tf                     # Input variables (API key, base URL)
├── resource_definition.tf           # Custom "mlb" resource type definition
├── catalog.tf                       # Cortex catalog (mlb-seasons)
├── seasons.tf                       # Module instantiation for seasons
├── seasons/
│   └── 2026/
│       ├── providers.tf             # Provider config for season module
│       ├── season.tf                # Season entity (mlb-2026)
│       ├── leagues.tf               # League entities (al-2026, nl-2026)
│       └── divisions.tf             # Division module calls (6 calls)
├── modules/
│   └── mlb-division/
│       ├── main.tf                  # Division + team entities
│       ├── variables.tf             # Module inputs
│       ├── outputs.tf               # Module outputs
│       └── versions.tf              # Provider version constraint
├── .gitignore                       # Standard Terraform .gitignore
├── .terraform/                      # Provider plugins (auto-generated)
├── .terraform.lock.hcl              # Dependency lock file
└── README.md                        # This file
```

---

## Adding a New Season

To add a new season (e.g., 2027), follow these steps:

### 1. Create the Season Directory

```bash
mkdir -p seasons/2027
```

### 2. Copy Season Files from 2026

```bash
cp seasons/2026/providers.tf seasons/2027/
cp seasons/2026/season.tf seasons/2027/
cp seasons/2026/leagues.tf seasons/2027/
cp seasons/2026/divisions.tf seasons/2027/
```

### 3. Update `seasons/2027/season.tf`

Change the year in the tag and name:

```hcl
resource "cortex_catalog_entity" "mlb_season" {
  tag         = "mlb-2027"
  name        = "MLB 2027"
  description = "Major League Baseball — 2027 Season"
  type        = "mlb"
  groups      = ["mlb-season"]
}
```

### 4. Update `seasons/2027/leagues.tf`

Change all year references from `2026` to `2027`:

```hcl
resource "cortex_catalog_entity" "al_league" {
  tag         = "al-2027"
  name        = "American League 2027"
  description = "American League — MLB 2027 Season"
  type        = "mlb"
  groups      = ["mlb-league-2027"]

  parents = [
    { tag = "mlb-2027" }
  ]

  depends_on = [cortex_catalog_entity.mlb_season]
}

resource "cortex_catalog_entity" "nl_league" {
  tag         = "nl-2027"
  name        = "National League 2027"
  description = "National League — MLB 2027 Season"
  type        = "mlb"
  groups      = ["mlb-league-2027"]

  parents = [
    { tag = "mlb-2027" }
  ]

  depends_on = [cortex_catalog_entity.mlb_season]
}
```

### 5. Update `seasons/2027/divisions.tf`

Change year references and update parent tags to point to the new leagues:

```hcl
module "al_east_2027" {
  source = "../../modules/mlb-division"

  year       = "2027"
  division   = "AL East"
  league_tag = "al-2027"

  teams = [
    # ... team list
  ]
}

module "al_central_2027" {
  source = "../../modules/mlb-division"

  year       = "2027"
  division   = "AL Central"
  league_tag = "al-2027"

  teams = [
    # ... team list
  ]
}

# ... repeat for AL West, NL East, NL Central, NL West
```

### 6. Add Module Call to Root `seasons.tf`

```hcl
module "season_2027" {
  source = "./seasons/2027"
}
```

### 7. Apply

```bash
terraform plan   # Review new 39 entities
terraform apply  # Create 2027 season
```

**Note:** The `mlb-division` module is reusable and requires no changes. Only the season directory and root `seasons.tf` need updating.

---

## GitOps Upgrade Path

This repository demonstrates a **four-stage ladder** for scaling Terraform from local development to enterprise GitOps:

### Stage 1: Local (Current)

**Status:** Fully functional
**How:** Run `terraform apply` from your laptop
**Pros:**
- Simple, immediate feedback
- Full control and visibility

**Cons:**
- Manual CI/CD
- Hard to audit who changed what
- State stored locally (unsafe)

**Checklist:**
- [x] `terraform init` works
- [x] `terraform plan` reviews changes
- [x] `terraform apply` creates resources

---

### Stage 2: HCP Terraform Free Tier

**Status:** Next step
**How:** Migrate state to Terraform Cloud, run `terraform plan` on PR

**Setup:**
1. Create free HCP Terraform account at [app.terraform.io](https://app.terraform.io)
2. Generate API token in Settings → Tokens
3. Create `cloud` block in `main.tf`:
   ```hcl
   cloud {
     organization = "my-org"
     workspaces {
       name = "cortex-terraform-mlb"
     }
   }
   ```
4. Authenticate:
   ```bash
   terraform login  # Paste API token
   ```
5. Migrate state:
   ```bash
   terraform init  # Select "yes" to migrate
   ```

**Benefits:**
- Remote state (secure, shared)
- Plan on every PR (visibility)
- Runs recorded in web UI
- Free tier supports 1 organization

**Checklist:**
- [ ] HCP Terraform account created
- [ ] `cloud` block added to `main.tf`
- [ ] VCS integration configured (GitHub)
- [ ] Plan-on-PR automation working

---

### Stage 3: GitHub Actions

**Status:** For advanced CI/CD
**How:** Trigger `terraform plan` and `terraform apply` from GitHub workflows

**Setup:**
1. Create `.github/workflows/terraform.yml`:
   ```yaml
   name: Terraform

   on:
     pull_request:
       paths:
         - '**.tf'
         - '.github/workflows/terraform.yml'
     push:
       branches: [main]
       paths:
         - '**.tf'

   jobs:
     terraform:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - uses: hashicorp/setup-terraform@v2
           with:
             terraform_version: 1.5
             cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}
         - run: terraform init
         - run: terraform plan -out=tfplan
         - name: Comment Plan on PR
           if: github.event_name == 'pull_request'
           uses: actions/github-script@v6
           with:
             script: |
               // Parse tfplan and post comment to PR
         - run: terraform apply tfplan
           if: github.ref == 'refs/heads/main' && github.event_name == 'push'
   ```

2. Add `TF_API_TOKEN` secret to GitHub repo settings

**Benefits:**
- Plan runs automatically on PR
- Apply runs only on merge to main
- Full audit trail in GitHub Actions
- Team review workflow

**Checklist:**
- [ ] `.github/workflows/terraform.yml` created
- [ ] `TF_API_TOKEN` secret added
- [ ] First PR plan triggered successfully
- [ ] Merge to main triggers apply

---

### Stage 4: Terragrunt (Multi-Season at Scale)

**Status:** For enterprise with many seasons/workspaces
**How:** Use Terragrunt to manage multiple seasons with shared configs and remote state per season

**Concept:**
```
terragrunt/
├── terragrunt.hcl              # Global config
├── 2026/
│   ├── terragrunt.hcl          # Season-specific config
│   └── main.tf                 # Season 2026 resources
├── 2027/
│   ├── terragrunt.hcl          # Season-specific config
│   └── main.tf                 # Season 2027 resources
└── 2028/
    └── ...
```

**Setup:**
1. Install [Terragrunt](https://terragrunt.io):
   ```bash
   brew install terragrunt  # or equivalent for your OS
   ```

2. Create global `terragrunt.hcl`:
   ```hcl
   remote_state {
     backend = "s3"
     config = {
       bucket         = "my-org-tf-state"
       key            = "${path_relative_to_include()}/terraform.tfstate"
       region         = "us-east-1"
       encrypt        = true
       dynamodb_table = "terraform-locks"
     }
   }
   ```

3. Create `2026/terragrunt.hcl`:
   ```hcl
   include "root" {
     path = find_in_parent_folders()
   }

   inputs = {
     year = "2026"
   }
   ```

4. Run from any directory:
   ```bash
   terragrunt run-all init      # Init all seasons
   terragrunt run-all plan      # Plan all seasons
   terragrunt run-all apply     # Apply all seasons
   ```

**Benefits:**
- Single command to manage all seasons
- Per-season S3 state files and DynamoDB locks
- DRY: shared configs across seasons
- Scales to hundreds of seasons

**Checklist:**
- [ ] Terragrunt installed
- [ ] S3 bucket and DynamoDB table created
- [ ] Global `terragrunt.hcl` configured
- [ ] Per-season `terragrunt.hcl` files created
- [ ] `terragrunt run-all` commands tested

---

## Contributing

Contributions are welcome! Here are a few ways to help:

### Report Issues
If you encounter problems applying this repository:
1. Check the [Known Issues](#known-issues--workarounds) section above
2. Search [terraform-provider-cortex issues](https://github.com/cortexapps/terraform-provider-cortex/issues)
3. Open a new issue with:
   - Terraform version (`terraform version`)
   - Provider version (check `.terraform.lock.hcl`)
   - Error message and stack trace

### Contribute to terraform-provider-cortex

This project uses the [cortexapps/cortex Terraform provider](https://github.com/cortexapps/terraform-provider-cortex). Improvements to the provider benefit all users:

1. **Custom-type entity creation bug:** Contribute a fix to handle custom types in entity creation (see [Known Issues](#known-issues--workarounds))
2. **Catalog resource support:** The `cortex_catalog` resource exists in `feature/catalog-resource` branch — help merge it to main
3. **New resources:** Add support for scorecard rules, verification definitions, or other Cortex objects

### Contribute to This Repository

- **New example seasons:** Add 2025, 2024, or other years
- **Terragrunt examples:** Create a `terragrunt/` directory with complete setup
- **GitHub Actions workflow:** Add `.github/workflows/terraform.yml` with PR/merge automation
- **Documentation:** Improve this README or add troubleshooting guides

---

## Resources

- **Terraform Documentation:** https://www.terraform.io/docs
- **Cortex Documentation:** https://docs.getcortexapp.com
- **Terraform Provider Cortex:** https://registry.terraform.io/providers/cortexapps/cortex/latest/docs
- **GitHub (Provider Source):** https://github.com/cortexapps/terraform-provider-cortex

---

## License

This reference project is provided as-is for educational and demonstration purposes.
