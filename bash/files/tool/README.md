# CLI Abbreviation Scheme

## System Overview

This scheme creates consistent, conflict-free abbreviations for CLI tools using:
- **3-letter tool prefixes** (with exceptions)
- **2-letter action suffixes**
- **2-letter resource abbreviations**
- **Single-letter flag suffixes**

## Core Rules

| Rule | Description | Example |
|------|-------------|---------|
| **Tool Prefixes** | 3-letter consonant patterns, drop vowels | **kub**ectl → `kbt`, **doc**ker → `dck` |
| **Vowel Exception** | Keep vowels when tool starts with one | **aws** → `aws`, **ist**io → `ist` |
| **Actions** | All actions use 2-letter suffixes | `list` → `la`, `show` → `sh`, `get` → `gt` |
| **Natural Order** | Follow actual command structure | `terraform workspaces list` → `trfwsla` |
| **Flag Suffixes** | Single letters after actions | `git commit --amend` → `gcma` |

## Exceptions Table

| Tool | Exception | Reason |
|------|-----------|---------|
| git | `g` | Most frequent tool |
| github | `gh` | Official CLI name |
| aws | `aws` | Starts with vowel |
| istio | `ist` | Starts with vowel |

## Pattern Structure

### Basic Pattern
```
[tool][action][resource?][flag?]
```

### Multi-level Pattern
```
[tool][subcommand][resource][action][flag?]
```

### Examples
| Command | Pattern | Abbreviation |
|---------|---------|--------------|
| `git status` | `[g][st]` | `gst` |
| `kubectl get pods` | `[kbt][gt][po]` | `kbtgtpo` |
| `git commit --amend` | `[g][cm][a]` | `gcma` |
| `terraform workspaces list` | `[trf][ws][la]` | `trfwsla` |

## Tool Prefixes

### Core DevOps Tools
| Tool | Prefix | Pattern | Example |
|------|--------|---------|---------|
| git | `g` | exception | `gst` (git status) |
| kubectl | `kbt` | **kub**e**ct**l | `kbtgtpo` (kubectl get pods) |
| docker | `dck` | **d**o**ck**er | `dckps` (docker ps) |
| helm | `hlm` | **h**e**l**m | `hlmla` (helm list) |
| terraform | `trf` | **t**e**r**rafor**m** | `trfap` (terraform apply) |
| ansible | `ans` | **an**s**ible | `anspl` (ansible-playbook) |
| vagrant | `vgr` | **v**a**gr**ant | `vgrup` (vagrant up) |

### Cloud & Infrastructure
| Tool | Prefix | Pattern | Example |
|------|--------|---------|---------|
| gcloud | `gcl` | **g**c**l**oud | `gclila` (gcloud list) |
| awscli | `aws` | vowel exception | `awsla` (aws list) |
| azure | `azr` | **az**u**r**e | `azrla` (azure list) |
| consul | `cns` | **c**o**ns**ul | `cnsla` (consul list) |
| vault | `vlt` | **v**au**lt** | `vltla` (vault list) |
| nomad | `nmd` | **n**o**m**ad | `nmdst` (nomad status) |
| packer | `pck` | **p**a**ck**er | `pckbl` (packer build) |

### Container Orchestration
| Tool | Prefix | Pattern | Example |
|------|--------|---------|---------|
| podman | `pdm` | **p**od**m**an | `pdmps` (podman ps) |
| minikube | `mnk` | **m**i**n**i**k**ube | `mnksr` (minikube start) |
| istio | `ist` | vowel exception | `istla` (istio list) |
| skaffold | `skf` | **sk**a**f**fold | `skfrn` (skaffold run) |
| linkerd | `lnk` | **l**i**nk**erd | `lnkst` (linkerd status) |

### Development Tools
| Tool | Prefix | Pattern | Example |
|------|--------|---------|---------|
| github | `gh` | exception | `ghla` (gh list) |
| gradle | `grd` | **gr**a**d**le | `grdbl` (gradle build) |
| maven | `mvn` | **m**a**v**en | `mvncm` (maven compile) |
| cargo | `crg` | **c**a**rg**o | `crgbl` (cargo build) |
| webpack | `wpk` | **w**eb**p**ac**k** | `wpkbl` (webpack build) |

### Monitoring & Observability
| Tool | Prefix | Pattern | Example |
|------|--------|---------|---------|
| prometheus | `prm` | **pr**o**m**etheus | `prmst` (prometheus status) |
| grafana | `grf` | **gr**a**f**ana | `grfsr` (grafana start) |
| jaeger | `jgr` | **j**ae**g**e**r** | `jgrst` (jaeger status) |

### Compose & Multi-tool
| Tool | Prefix | Pattern | Example |
|------|--------|---------|---------|
| docker-compose | `dcp` | **d**o**c**ker-com**p**ose | `dcpup` (docker-compose up) |
| starship | `str` | **st**a**r**ship | `strtg` (starship toggle) |

## Action Suffixes

### Core Actions
| Action | Suffix | Usage |
|--------|--------|-------|
| apply | `ap` | terraform, kubectl |
| add | `ad` | git, general |
| create | `cr` | kubectl, cloud |
| commit | `cm` | git |
| delete | `dl` | kubectl, general |
| get | `gt` | kubectl, general |
| list | `la` | most tools |
| logs | `lg` | kubectl, docker |
| run | `rn` | docker, general |
| status | `st` | git, general |
| show | `sh` | terraform, general |
| plan | `pl` | terraform |
| pull | `pl` | git (context-dependent) |
| push | `ps` | git, docker |

### Management Actions
| Action | Suffix | Usage |
|--------|--------|-------|
| start | `sr` | services, VMs |
| describe | `ds` | kubectl, cloud |
| exec | `ex` | kubectl, docker |
| port-forward | `pf` | kubectl |
| rebase | `rb` | git |
| rollback | `rb` | deployment (context-dependent) |
| switch | `sw` | git, kubectl |
| select | `sl` | terraform |
| install | `in` | helm, package managers |
| build | `bl` | gradle, docker |
| toggle | `tg` | starship, configs |
| up | `up` | vagrant, docker-compose |

## Flag Suffixes

| Flag | Suffix | Common Usage |
|------|--------|--------------|
| --amend | `a` | git commit |
| --force | `f` | git push, helm |
| --watch | `w` | kubectl get |
| --dry-run | `d` | terraform, kubectl |
| --verbose | `v` | most tools |
| --quiet | `q` | docker, general |
| --recursive | `r` | file operations |
| --interactive | `i` | git, general |
| --yes | `y` | auto-confirm |
| --no | `n` | simulate/test |

## Resource Abbreviations

| Resource | Abbreviation | Usage |
|----------|--------------|-------|
| pods | `po` | kubectl |
| services | `sv` | kubectl |
| deployments | `dp` | kubectl |
| namespaces | `ns` | kubectl |
| secrets | `sc` | kubectl |
| configmaps | `cm` | kubectl |
| nodes | `no` | kubectl |
| branch | `br` | git |
| workspace | `ws` | terraform |

## Examples

### Basic Commands
| Command | Abbreviation | Pattern |
|---------|--------------|---------|
| `git status` | `gst` | `[g][st]` |
| `git commit` | `gcm` | `[g][cm]` |
| `kubectl get pods` | `kbtgtpo` | `[kbt][gt][po]` |
| `helm list` | `hlmla` | `[hlm][la]` |
| `terraform apply` | `trfap` | `[trf][ap]` |
| `docker-compose up` | `dcpup` | `[dcp][up]` |

### Commands with Flags
| Command | Abbreviation | Pattern |
|---------|--------------|---------|
| `git commit --amend` | `gcma` | `[g][cm][a]` |
| `git push --force` | `gpsf` | `[g][ps][f]` |
| `kubectl get pods --watch` | `kbtgtpow` | `[kbt][gt][po][w]` |
| `terraform apply --dry-run` | `trfapd` | `[trf][ap][d]` |

### Multi-level Commands
| Command | Abbreviation | Pattern |
|---------|--------------|---------|
| `terraform workspaces list` | `trfwsla` | `[trf][ws][la]` |
| `gcloud compute instances list` | `gclcila` | `[gcl][c][i][la]` |
| `kubectl describe pods` | `kbtdspo` | `[kbt][ds][po]` |

### Command Prefix Aliases
| Prefix | Full Command | Usage |
|--------|-------------|-------|
| `trfws` | `terraform workspace` | `trfws la`, `trfws sh` |
| `gclci` | `gcloud compute instances` | `gclci la`, `gclci cr` |
| `kbtgt` | `kubectl get` | `kbtgt po`, `kbtgt no` |
| `awsec2` | `aws ec2` | `awsec2 la`, `awsec2 cr` |

## Future-Proofing Strategy

- **Systematic expansion**: Clear rules for adding new tools and actions
- **Conflict avoidance**: 3-letter prefixes and 2-letter actions prevent Unix conflicts
- **Memorable patterns**: Consonant-based abbreviations follow Unix traditions
- **Flexible structure**: Handles simple commands to complex multi-level operations
