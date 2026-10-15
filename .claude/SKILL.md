# Keeping cortex/ in Sync with Terraform

This repo maintains three parallel representations of the same Cortex entity catalog:

| Approach | Location | How it works |
|---|---|---|
| **Terraform** | root `.tf` files | `terraform apply` pushes changes via the Cortex Terraform provider |
| **GitOps** | `cortex/comparison/gitops/` | YAML entity descriptors synced via the Cortex GitOps integration |
| **CLI** | `cortex/comparison/cli/` | Matches the output of `cortex backup export` — importable via `cortex backup import` |

All three represent identical entities. The `cortex/comparison/` folder exists for instructional comparison — showing how the same catalog is expressed across all three approaches.

---

## Folder Structure

```
cortex/
└── comparison/
    ├── gitops/
    │   ├── supported/               ← equivalent to .cortex/ in a GitOps repo
    │   │   └── catalog/             ← the only supported subfolder for custom entities
    │   │       ├── seasons/2026/    ← season, league, division YAMLs
    │   │       │   └── teams/       ← all 30 MLB team YAMLs
    │   │       ├── leaders/         ← 12 statistical leader YAMLs
    │   │       └── athletics-roster-2026.yaml
    │   └── not-supported/           ← things GitOps cannot manage (API/UI only)
    │       ├── resource-definitions/
    │       └── relationship-types/
    └── cli/
        ├── catalog/                   ← all entities flat, same YAML format
        ├── entity-types/              ← resource definitions as JSON
        ├── entity-relationship-types/ ← relationship type definitions as JSON
        └── entity-relationships/      ← relationship instances as JSON arrays
```

---

## Key Differences Between Approaches

| Concern | Terraform | GitOps | CLI |
|---|---|---|---|
| **Entity format** | HCL with `jsonencode()` | `openapi: 3.0.1` YAML with `x-cortex-*` fields | Same `openapi: 3.0.1` YAML |
| **Resource definitions** | `cortex_resource_definition` resource | ❌ Not supported — API/UI only | `entity-types/*.json` |
| **Relationship types** | `cortex_relationship_type` resource | ❌ Not supported — API/UI only | `entity-relationship-types/*.json` |
| **Relationships** | `cortex_entity_relationship` resource | Inline `x-cortex-relationships:` in source entity | `entity-relationships/*.json` (arrays by type) |
| **Entity organization** | Modular (division module loops over teams) | Subdirs under `catalog/` | Flat `catalog/` directory |
| **Abstraction/reuse** | Terraform modules — 6 module calls create 30 teams | No abstraction — 1 file per entity | No abstraction — 1 file per entity |
| **Dependency ordering** | `depends_on` graph | GitOps handles order | Two-pass import for relationships |
| **Metadata/definition** | Separate `jsonencode()` blocks | `x-cortex-custom-metadata:` / `x-cortex-definition:` | Same as GitOps |

---

## Folder Mapping to Terraform

```
Terraform                                   GitOps                              CLI
─────────────────────────────────────────────────────────────────────────────────────────────
resource_definition.tf                   → gitops/not-supported/               cli/entity-types/
relationship_type.tf                     → gitops/not-supported/               cli/entity-relationship-types/
relationships.tf                         → x-cortex-relationships: in entity   cli/entity-relationships/
seasons/2026/season.tf                   → gitops/supported/catalog/seasons/   cli/catalog/mlb-2026.yaml
seasons/2026/leagues.tf                  → gitops/supported/catalog/seasons/   cli/catalog/al-2026.yaml, nl-2026.yaml
seasons/2026/divisions.tf                → gitops/supported/catalog/seasons/   cli/catalog/{division}-2026.yaml
modules/mlb-division/ (teams)            → gitops/supported/catalog/.../teams/ cli/catalog/{team}-2026.yaml
seasons/2026/teams.tf                    → gitops/supported/catalog/           cli/catalog/athletics-roster-2026.yaml
leaders.tf                               → gitops/supported/catalog/leaders/   cli/catalog/2026-{league}-leader-{cat}.yaml
```

---

## When Updating This Repo

When Terraform entity data changes, mirror the same update in both `gitops/` and `cli/`:

| Change in Terraform | GitOps update | CLI update |
|---|---|---|
| Team wins/losses in `divisions.tf` | `x-cortex-custom-metadata` in team YAML (both paths) | Same YAML in `cli/catalog/` |
| Leader stats in `leaders.tf` | `x-cortex-definition` + `x-cortex-custom-metadata` | Same YAML in `cli/catalog/` |
| New team added | New YAML in `gitops/supported/catalog/.../teams/` | New YAML in `cli/catalog/` |
| Athletics roster in `teams.tf` | `x-cortex-custom-metadata.roster` in both YAMLs | Same |
| Resource definition schema change | Update `gitops/not-supported/resource-definitions/` | Update `cli/entity-types/` |
| Relationship type change | Update `gitops/not-supported/relationship-types/` | Update `cli/entity-relationship-types/` |
| New relationship added | Add to `x-cortex-relationships:` in source entity | Add entry to `cli/entity-relationships/{type}.json` |

---

## GitOps YAML Format Quick Reference

```yaml
openapi: 3.0.1
info:
  title: Entity Display Name
  x-cortex-tag: entity-tag
  x-cortex-type: mlb                    # custom resource type
  x-cortex-description: "Description"
  x-cortex-groups:
    - group-name
  x-cortex-parents:
    - tag: parent-entity-tag
  x-cortex-owners:
    - name: owner-team-tag
      type: group
      provider: CORTEX
  x-cortex-relationships:               # expresses custom relationship type instances
    - tag: destination-entity-tag
      type: relationship-type-tag
  x-cortex-definition:                  # typed definition (custom resource types only)
    key: value
  x-cortex-custom-metadata:
    key: value
```

## CLI Commands

```bash
# Export current state from Cortex
cortex backup export -d cortex/comparison/cli/

# Import into Cortex
cortex backup import -d cortex/comparison/cli/

# Import only catalog entities
cortex backup import -d cortex/comparison/cli/ -e catalog
```
