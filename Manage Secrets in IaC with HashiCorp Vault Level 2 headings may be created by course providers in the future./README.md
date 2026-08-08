<div align="center">

# 🔐 Manage Secrets in IaC with HashiCorp Vault

![Vault](https://img.shields.io/badge/HashiCorp-Vault-000000?style=for-the-badge&logo=vault&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-Vault%20Provider-844FBA?style=for-the-badge&logo=terraform&logoColor=white)
![Secrets](https://img.shields.io/badge/Focus-Secrets%20Management-D32F2F?style=for-the-badge)
![Difficulty](https://img.shields.io/badge/Difficulty-Advanced-red?style=for-the-badge)
![Format](https://img.shields.io/badge/Format-Design%20Brief-6f42c1?style=for-the-badge)

**Deploy Vault, wire it into Terraform for dynamic secret injection, and prove rotation propagates cleanly**

</div>

---

## 📑 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Environment Setup](#️-environment-setup)
- [🧩 Tasks](#-tasks)
  - [Task 1: 🗝️ Deploy Vault in Dev Mode and Configure Secrets Engine](#task-1-🗝️-deploy-vault-in-dev-mode-and-configure-secrets-engine)
  - [Task 2: 🔗 Terraform Integration with Vault Provider](#task-2-🔗-terraform-integration-with-vault-provider)
  - [Task 3: 🔄 Apply, Verify, and Rotate](#task-3-🔄-apply-verify-and-rotate)
- [🛡️ MITRE ATT&CK Mapping](#️-mitre-attck-mapping)
- [🔑 Key Concepts](#-key-concepts)
- [✅ Verification](#-verification)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

| # | Objective |
|---|-----------|
| 1 | Deploy HashiCorp Vault in dev mode to manage infrastructure secrets |
| 2 | Integrate Terraform with the Vault provider for dynamic secret retrieval |
| 3 | Generate configuration files with injected secrets without plaintext exposure in code |
| 4 | Perform secret rotation and validate propagation through the IaC pipeline |

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| Terraform | Strong understanding (providers, resources, state, variables) |
| Vault concepts | Secrets engines, tokens, policies, KV versioning |
| Linux CLI | Proficiency with systemd, curl, package management |
| DevOps context | Basic understanding of secrets lifecycle management in pipelines |

## 🖥️ Environment Setup

> - Single Linux machine (Ubuntu/Debian or RHEL-based) provisioned via Start Lab
> - Root/sudo access required
> - Outbound internet access for package downloads
> - Install required tooling independently using official HashiCorp APT/YUM repositories or binary releases

**Verify versions:**

```bash
vault version
terraform version
```

> ℹ️ Both should be recent stable releases (Vault 1.15+, Terraform 1.6+).

---

## 🧩 Tasks

> 🧭 **Format note:** This lab is a design brief. Requirements, deliverables, and starter skeletons are given — the configuration, security decisions, and research questions are yours to work through.

### Task 1: 🗝️ Deploy Vault in Dev Mode and Configure Secrets Engine

**Requirements:**
- Start Vault in dev mode, bound to `127.0.0.1:8200`
- Capture the generated root token and unseal key from dev server output
- Export required environment variables (`VAULT_ADDR`, `VAULT_TOKEN`) for CLI operations
- Enable a KV Version 2 secrets engine at a custom path (e.g., `secret/`)
- Design your secret path hierarchy to reflect a real infra layout, e.g.:
  ```
  secret/database/prod
  secret/api/external-service
  ```

**Deliverable:** Store the following secrets under appropriate paths:
- `db_password`, `db_username`
- `api_key`, `api_endpoint`

Use `vault kv put` and confirm with `vault kv get`. Document your path design decisions (why KV v2, why this hierarchy) in a short `NOTES.md`.

**Considerations:**
- Dev mode stores everything in-memory — data is lost on restart. Note implications for production use vs. this lab context.
- 🔎 **Research:** what changes would be required to run Vault in production mode with persistent storage (file/Consul/Raft backend) instead?

### Task 2: 🔗 Terraform Integration with Vault Provider

**Architecture:**

```
Terraform Config
  ├── provider "vault" (auth via token)
  ├── data "vault_kv_secret_v2" (fetch db + api secrets)
  ├── locals (map/transform secret attributes)
  └── resource "local_file" (render templated config using secrets)
```

**Requirements:**
- Configure the `vault` provider block — decide how to supply address/token securely (avoid hardcoding token in `.tf` files; consider environment variables or a `.tfvars` file excluded from version control)
- Use the `vault_kv_secret_v2` (or equivalent current data source) to fetch secrets from both paths created in Task 1
- Create a `templatefile()`-driven `local_file` resource that renders an application config (e.g., `app_config.conf` or `.yaml`) embedding the fetched values

**Starter skeleton — complete the implementation:**

```hcl
# providers.tf
terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
}

provider "vault" {
  # TODO: address and token configuration
  # Decide: variable, env var (VAULT_TOKEN), or file-based?
}
```

```hcl
# data.tf
data "vault_kv_secret_v2" "db" {
  # TODO: mount, name
}

data "vault_kv_secret_v2" "api" {
  # TODO: mount, name
}
```

```hcl
# main.tf
locals {
  # TODO: build a map of rendered values from data sources
}

resource "local_file" "app_config" {
  filename = "${path.module}/output/app_config.conf"
  content  = templatefile("${path.module}/templates/app_config.tpl", {
    # TODO: pass required secret values
  })
}
```

```hcl
# templates/app_config.tpl
# TODO: design a template referencing ${db_username}, ${db_password}, ${api_key}, ${api_endpoint}
```

**Design decisions to make:**
- Should the `local_file` output directory be gitignored? Why?
- How do you prevent secret values from appearing in `terraform plan` output logs or CI/CD console logs?
- Investigate `sensitive = true` on outputs/variables — apply where relevant.

### Task 3: 🔄 Apply, Verify, and Rotate

**1️⃣ Run the standard workflow:**

```bash
terraform init
terraform plan
terraform apply
```

**2️⃣ Inspect plan output** — confirm secret values are marked `(sensitive value)` rather than shown in plaintext.

**3️⃣ Verify generated file contents match Vault-stored secrets** (inspect `output/app_config.conf` directly on disk, not via Terraform output).

**Rotation exercise:**
- Update `db_password` in Vault using `vault kv put` (KV v2 auto-versions)
- Re-run `terraform plan` — determine whether Terraform detects the change automatically, or whether a `-refresh` or taint/replace is needed
- 🔎 **Document your finding:** does the `vault_kv_secret_v2` data source refresh on every plan by default? Why or why not (research data source refresh behavior)?
- Re-apply and confirm the new secret value propagates into the config file

**Edge cases to address:**
- What happens if the secret path or key name doesn't exist? How does Terraform behave (error handling)?
- What if the Vault dev server restarts mid-workflow (token invalidated)? How would you detect and recover in a real pipeline?

---

## 🛡️ MITRE ATT&CK Mapping

| Technique ID | Name | Relevance to This Lab |
|---|---|---|
| T1552 | Unsecured Credentials | Core theme of the lab — moving secrets out of plaintext `.tf` files and into Vault |
| T1552.001 | Credentials In Files | The `.gitignore`/output-directory design decision directly guards against this |
| T1078 | Valid Accounts | `VAULT_TOKEN` handling and rotation practices reduce risk from a compromised token |
| T1555 | Credentials from Password Stores | Vault itself is a password/secrets store — dev-mode's in-memory nature is a noted limitation |
| T1552.007 | Container API | Relevant if this pipeline later runs in containerized CI (Docker socket/API credential exposure) |

## 🔑 Key Concepts

| Concept | Description |
|---|---|
| **Vault dev mode** | An in-memory, auto-unsealed Vault instance for local development — never for production |
| **KV v2 secrets engine** | A versioned key-value store in Vault; supports secret history and rollback |
| **`vault_kv_secret_v2` data source** | Terraform's read interface into a KV v2 path, fetched at plan/apply time |
| **`sensitive = true`** | Marks a Terraform variable/output so its value is redacted from CLI output |
| **`templatefile()`** | Renders a template file with injected variables, useful for generating config files without embedding secrets directly in `.tf` code |
| **Secret rotation** | Updating a credential's value and confirming all consumers pick up the new value |
| **Data source refresh** | Whether/when Terraform re-reads a data source's value on subsequent plans |

## ✅ Verification

Confirm the following on your machine:

```bash
vault kv get secret/database/prod
vault kv get -version=1 secret/database/prod   # confirm version history exists
cat output/app_config.conf                      # matches latest secret values
terraform state list                             # data sources + local_file present
```

**Additional checks:**
- `terraform plan` after rotation shows a diff/update for `local_file.app_config`
- No secret values appear in `terraform show` in plaintext unless explicitly marked non-sensitive
- `app_config.conf` reflects the rotated `db_password`

## 🏁 Conclusion

In this lab, you deployed HashiCorp Vault in dev mode, designed a KV v2 secret path hierarchy, and integrated it with Terraform using the Vault provider's data sources. You built a pipeline that dynamically fetches secrets and renders them into a templated configuration file via `local_file`, while evaluating how Terraform handles sensitive values in plan/apply output. Finally, you performed a live secret rotation in Vault and analyzed Terraform's data source refresh behavior to confirm propagation.

**🎯 Key Accomplishments:**
- ✅ Deployed Vault in dev mode with a designed KV v2 path hierarchy
- ✅ Integrated the Vault provider into Terraform via data sources
- ✅ Rendered secrets into a config file with `templatefile()` while avoiding plaintext exposure
- ✅ Evaluated `sensitive` handling in Terraform plan/apply output
- ✅ Performed and validated a live secret rotation end-to-end

**🌍 Real-World Applications:**
These skills directly map to real-world secrets management patterns required for the HashiCorp Vault Associate certification and production DevOps/Security Engineer responsibilities, including secure secret injection, avoiding hardcoded credentials, and managing secret lifecycle in IaC workflows.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
