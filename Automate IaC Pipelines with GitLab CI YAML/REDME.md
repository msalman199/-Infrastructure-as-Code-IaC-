<div align="center">

# 🦊 Automate IaC Pipelines with GitLab CI YAML

![GitLab CI](https://img.shields.io/badge/GitLab-CI%2FCD-FC6D26?style=for-the-badge&logo=gitlab&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-Local%20Provider-844FBA?style=for-the-badge&logo=terraform&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Runner%20Executor-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Difficulty](https://img.shields.io/badge/Difficulty-Advanced-red?style=for-the-badge)
![Format](https://img.shields.io/badge/Format-Design%20Brief-6f42c1?style=for-the-badge)

**Architect a self-hosted GitLab Runner and a three-stage Terraform CI/CD pipeline — validate, plan, apply**

</div>

---

## 📑 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Environment Setup](#️-environment-setup)
- [🧩 Tasks](#-tasks)
  - [Task 1: 🏃 Install and Register GitLab Runner (Docker Executor)](#task-1-🏃-install-and-register-gitlab-runner-docker-executor)
  - [Task 2: 🌱 Initialize Terraform Project with Local Provider](#task-2-🌱-initialize-terraform-project-with-local-provider)
  - [Task 3: 🏗️ Design the Multi-Stage Pipeline](#task-3-🏗️-design-the-multi-stage-pipeline)
  - [Task 4: 🔎 Trigger and Inspect Pipeline](#task-4-🔎-trigger-and-inspect-pipeline)
- [🔑 Key Concepts](#-key-concepts)
- [✅ Verification](#-verification)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

| # | Objective |
|---|-----------|
| 1 | Deploy and register a Dockerized GitLab Runner on a single Linux host |
| 2 | Architect a multi-stage `.gitlab-ci.yml` pipeline (validate, plan, apply) for Terraform using the local provider |
| 3 | Implement artifact-based state handoff between plan and apply stages |
| 4 | Diagnose pipeline execution via runner and job logs |

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| CLI proficiency | Strong Linux, Git, and Docker skills |
| Terraform basics | `init`, `plan`, `apply`, providers |
| GitLab CI concepts | Stages, jobs, artifacts, runners |
| GitLab access | An account/instance (gitlab.com or self-hosted) with a project you control |

## 🖥️ Environment Setup

> Single Linux machine (Al Nafi Start Lab) with:
> - Docker Engine installed and running
> - Git installed
> - Terraform CLI installed (v1.x)
> - Outbound network access to your GitLab instance

**Verify baseline tools:**

```bash
docker --version
git --version
terraform --version
```

---

## 🧩 Tasks

> 🧭 **Format note:** This lab is a design brief, not a step-by-step script. Task 1 gives a literal reference command to adapt; Tasks 2–3 hand you requirements, deliverables, and skeleton files with `TODO`s for you to complete — the decisions and the code are yours to make.

### Task 1: 🏃 Install and Register GitLab Runner (Docker Executor)

**Design requirements:**
- Runner must run as a Docker container on the host, using the `docker` executor so pipeline jobs spin up isolated containers
- Runner needs Docker-in-Docker (`dind`) or the host's Docker socket mounted to allow container-based Terraform jobs
- Obtain a registration token from your GitLab project (**Settings > CI/CD > Runners**)

**Deliverables:**
- 🏃 Running `gitlab-runner` container registered to your project, tagged appropriately (e.g., `terraform-runner`)
- ⚙️ A working `config.toml` with the correct executor, image default, and volume mounts for Docker socket access

**Reference command shape (fill in specifics):**

```bash
docker run -d --name gitlab-runner --restart always \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest

docker exec -it gitlab-runner gitlab-runner register
# Supply: GitLab URL, registration token, executor=docker, default image
```

**Decision points to resolve yourself:**
- Which base Docker image should jobs default to (`hashicorp/terraform` vs custom image with git+terraform)?
- How will you scope runner tags vs. project CI/CD settings to ensure jobs pick up this runner?

### Task 2: 🌱 Initialize Terraform Project with Local Provider

**Requirements:**
- Git repo containing a minimal Terraform configuration using the local provider (e.g., managing a local file resource) — no cloud credentials required
- Repo structure should support CI execution (working directory, `.terraform` caching strategy)

**Deliverables:**
- 📄 `main.tf` defining `terraform { required_providers { local = ... } }` and at least one `local_file` resource
- 🚫 `.gitignore` excluding `.terraform/`, `*.tfstate`, `*.tfstate.backup`, and crash logs

```hcl
# main.tf - skeleton only
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

resource "local_file" "example" {
  # TODO: define filename and content
}
```

### Task 3: 🏗️ Design the Multi-Stage Pipeline

**Architecture:**

```
stages: [validate, plan, apply]

validate  -> plan  -> apply
  (fmt/validate)  (plan artifact)  (apply from artifact, manual gate)
```

**Requirements per stage:**

| Stage | Requirements |
|---|---|
| **validate** | Run `terraform fmt -check` and `terraform validate`; fail fast on formatting or syntax errors |
| **plan** | Run `terraform plan -out=tfplan`; persist `tfplan` (and `.terraform` dir or lock file) as a GitLab CI artifact for the next stage; consider artifact expiration and size |
| **apply** | Depend on plan stage artifacts (`needs` or `dependencies`); run `terraform apply tfplan`; decide — should this run automatically or require `when: manual`? Justify your choice in a comment in the YAML |

**Skeleton to complete:**

```yaml
image: hashicorp/terraform:latest   # or your custom image

variables:
  TF_IN_AUTOMATION: "true"

stages:
  - validate
  - plan
  - apply

before_script:
  # TODO: cd into terraform dir if needed, terraform init with backend config

validate:
  stage: validate
  script:
    # TODO: terraform fmt -check
    # TODO: terraform validate

plan:
  stage: plan
  script:
    # TODO: terraform init
    # TODO: terraform plan -out=tfplan
  artifacts:
    paths:
      # TODO: tfplan and any required state/lock files
    expire_in: "1 hour"

apply:
  stage: apply
  dependencies:
    - plan
  script:
    # TODO: terraform init
    # TODO: terraform apply tfplan
  when: manual   # justify or change based on your workflow design
```

**Edge cases to address:**
- `terraform init` must run in each job (state isolation per container) — ensure providers/lock file are consistent (commit `.terraform.lock.hcl`)
- Handle stale plan artifacts if `main.tf` changes between plan and apply (add a safeguard, e.g., checksum comparison or re-plan on apply failure)
- Runner image must have the `terraform` binary available or install it in `before_script`

### Task 4: 🔎 Trigger and Inspect Pipeline

**1️⃣ Commit Terraform files and `.gitlab-ci.yml`, push to GitLab.**

**2️⃣ Monitor pipeline under CI/CD > Pipelines.**

**3️⃣ Inspect each job's log for `terraform init`/`plan`/`apply` output.**

**4️⃣ Confirm artifact download in the apply job log** (should show the plan being consumed, not regenerated).

---

## 🔑 Key Concepts

| Concept | Description |
|---|---|
| **Docker executor** | A GitLab Runner mode where each job runs inside its own isolated Docker container |
| **Runner registration** | The process of connecting a runner instance to a GitLab project/group via a registration token |
| **CI/CD artifact** | A file (or set of files) a job produces and passes forward to later stages/jobs |
| **`dependencies` / `needs`** | Job keywords that control which prior job's artifacts are pulled into the current job |
| **`terraform plan -out=`** | Writes an execution plan to a file so it can be reviewed and later applied verbatim |
| **Manual gate (`when: manual`)** | Requires a human to trigger a job in the GitLab UI, commonly used before `apply` |
| **`TF_IN_AUTOMATION`** | An environment variable Terraform recognizes to adjust output for non-interactive/CI contexts |

## ✅ Verification

- [ ] `docker ps` shows `gitlab-runner` container active; runner appears "green" (online) in GitLab project runner settings
- [ ] Pipeline in GitLab UI shows three sequential stages, all passing (or apply awaiting manual trigger if configured)
- [ ] `apply` job log confirms it used the `tfplan` artifact (look for "Plan file" reference in output), not a fresh plan
- [ ] Local filesystem on the runner container/host reflects the resource created by `local_file` (verify via job log output or a follow-up `cat` step you design)
- [ ] Re-running the pipeline with no code changes shows validate/plan succeed with no diffs (idempotency check)

## 🏁 Conclusion

You architected and deployed a self-hosted GitLab Runner using the Docker executor, then built a three-stage Terraform CI/CD pipeline (validate, plan, apply) with artifact-based state handoff between stages. This lab required independent decisions on runner configuration, image selection, artifact strategy, and apply-gating policy — core competencies for a DevOps/CI-CD Engineer implementing IaC automation without cloud provider dependencies.

**🎯 Key Accomplishments:**
- ✅ Deployed and registered a Docker-executor GitLab Runner
- ✅ Authored a minimal local-provider Terraform project suited for CI execution
- ✅ Designed a three-stage validate → plan → apply pipeline with artifact handoff
- ✅ Made and justified independent decisions on image selection, tagging, and apply-gating
- ✅ Diagnosed pipeline behavior through runner status and job logs

**🌍 Real-World Applications:**
Artifact-based plan/apply handoff, runner configuration, and manual approval gates are foundational patterns for any team running Terraform through CI/CD — directly transferable to cloud-backed pipelines once local resources are swapped for real providers.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
