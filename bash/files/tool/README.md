# CLI Abbreviation Scheme

## Rules

1. **Tool prefix is always first** (prevents conflicts)
2. **Action comes second** 
3. **Resource comes last** (when needed)
4. **Pattern**: `[tool][action][resource?]`

## Tool Prefixes

| Tool | Prefix | Example |
|------|--------|---------|
| git | `g` | `gs` (git status) |
| kubectl | `k` | `kgp` (kubectl get pods) |
| docker | `d` | `dps` (docker ps) |
| terraform | `tf` | `tfa` (terraform apply) |
| gcloud | `gc` | `gcl` (gcloud list) |
| github | `gh` | `ghl` (gh list) |
| skaffold | `sk` | `skr` (skaffold run) |
| docker-compose | `dc` | `dcu` (docker-compose up) |
| starship | `ss` | `sst` (starship toggle) |

## Action Suffixes

### Single Letter (Ultra-common)
- `a` - apply/add
- `c` - create
- `d` - delete
- `g` - get/list
- `l` - logs
- `r` - run
- `s` - status/show
- `p` - plan/push/pull (context-dependent)

### Two Letters (Specific)
- `ds` - describe
- `ex` - exec
- `pf` - port-forward
- `rb` - rebase/rollback
- `st` - start/stash
- `sw` - switch

## Resource Abbreviations

- `po` - pods
- `sv` - services
- `dp` - deployments
- `ns` - namespaces
- `sc` - secrets
- `cm` - configmaps
- `no` - nodes
- `br` - branch
- `ws` - workspace

## Examples

- `kgpo` - kubectl get pods
- `kdsdp` - kubectl describe deployments
- `tfa` - terraform apply
- `tfp` - terraform plan
- `gcl` - gcloud list
- `skr` - skaffold run
- `dcu` - docker-compose up
- `gco` - git commit
