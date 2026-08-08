<div align="center">

# 🌊 Terraform State Management and Drift Detection

![Terraform](https://img.shields.io/badge/Terraform-1.8.5-844FBA?style=for-the-badge&logo=terraform&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Ubuntu%2FDebian-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![State](https://img.shields.io/badge/Focus-State%20%26%20Drift-0052CC?style=for-the-badge)
![Difficulty](https://img.shields.io/badge/Difficulty-Intermediate-orange?style=for-the-badge)
![Provider](https://img.shields.io/badge/Provider-Local-0052CC?style=for-the-badge)

**Explore how Terraform tracks state, detect real-world drift, and practice safe state manipulation**

</div>

---

## 📑 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Environment Setup](#️-environment-setup)
- [🧩 Tasks](#-tasks)
  - [Task 1: 🏗️ Create a Terraform Project with the Local Provider](#task-1-🏗️-create-a-terraform-project-with-the-local-provider)
  - [Task 2: 🔍 Apply and Inspect the State File](#task-2-🔍-apply-and-inspect-the-state-file)
  - [Task 3: 🌪️ Simulate Configuration Drift](#task-3-🌪️-simulate-configuration-drift)
  - [Task 4: 🕵️ Detect Drift with terraform plan](#task-4-🕵️-detect-drift-with-terraform-plan)
  - [Task 5: 🔧 Reconcile Drift with terraform apply](#task-5-🔧-reconcile-drift-with-terraform-apply)
  - [Task 6: 📊 Inspect State with CLI Commands](#task-6-📊-inspect-state-with-cli-commands)
  - [Task 7: 🗑️ Remove a Resource from State](#task-7-🗑️-remove-a-resource-from-state)
- [🔑 Key Concepts](#-key-concepts)
- [✅ Verification](#-verification)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | Examine the structure of a Terraform state file (`terraform.tfstate`) |
| 2 | Simulate configuration drift by manually modifying managed resources |
| 3 | Use `terraform plan` to detect drift between real infrastructure and desired state |
| 4 | Reconcile drift using `terraform apply` |
| 5 | Inspect and manage state using `terraform state list`, `terraform state show`, and `terraform state rm` |

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| Terraform syntax | Basic familiarity (providers, resources) |
| Linux terminal | Comfortable using bash |
| IaC concepts | Understanding of what Infrastructure as Code means |
| Cloud account | ❌ Not required — this lab uses the Terraform **local provider** only |

## 🖥️ Environment Setup

> Al Nafi provides a single Linux machine via Start Lab. Use it for all steps below.

**1️⃣ Verify Terraform is installed:**

```bash
terraform -version
```

**2️⃣ If not installed, install it:**

```bash
sudo apt-get update && sudo apt-get install -y unzip curl
curl -LO https://releases.hashicorp.com/terraform/1.8.5/terraform_1.8.5_linux_amd64.zip
unzip terraform_1.8.5_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform -version
```

**3️⃣ Create a working directory:**

```bash
mkdir ~/tf-drift-lab && cd ~/tf-drift-lab
```

---

## 🧩 Tasks

### Task 1: 🏗️ Create a Terraform Project with the Local Provider

Create a file named `main.tf`. Complete the TODOs to provision three `local_file` resources.

```hcl
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"  # 🔌 official local provider
      version = "~> 2.5"
    }
  }
}

# TODO 1: Define a local_file resource named "config_a"
#   filename = "${path.module}/files/config_a.txt"
#   content  = "environment=dev\nversion=1.0"

# TODO 2: Define a local_file resource named "config_b"
#   filename = "${path.module}/files/config_b.txt"
#   content  = "environment=staging\nversion=1.0"

# TODO 3: Define a local_file resource named "config_c"
#   filename = "${path.module}/files/config_c.txt"
#   content  = "environment=prod\nversion=1.0"
```

**Initialize the project:**

```bash
terraform init
```

### Task 2: 🔍 Apply and Inspect the State File

**1️⃣ Apply the configuration:**

```bash
terraform apply -auto-approve
```

**2️⃣ View the generated files:**

```bash
ls -la files/
cat files/config_a.txt
```

**3️⃣ Inspect the state file structure:**

```bash
cat terraform.tfstate | less
```

- 🔎 Identify the `resources` array
- 🔎 Locate the `instances` block and attributes for `config_a`
- 🔎 Note the `content` value stored in state vs. the file on disk

> ❓ **Question to answer in your notes:** Where does Terraform store the "source of truth" — the file on disk, or the state file?

### Task 3: 🌪️ Simulate Configuration Drift

Manually edit `config_b.txt` outside of Terraform to simulate drift:

```bash
echo "environment=staging\nversion=2.0-hotfix" > files/config_b.txt
cat files/config_b.txt
```

> ⚠️ This change was made outside Terraform's workflow — Terraform is unaware of it yet.

### Task 4: 🕵️ Detect Drift with terraform plan

**Run:**

```bash
terraform plan
```

- 👀 Observe the diff Terraform shows for `config_b`
- ⚖️ Terraform compares real-world state (the file's actual content) against the desired state (defined in `main.tf`)
- 📝 Note the `~` symbol indicating an in-place update

> 🛠️ **Troubleshooting tip:** If `plan` shows no changes, confirm you edited the correct file path and that `content` in `main.tf` still specifies the original value.

### Task 5: 🔧 Reconcile Drift with terraform apply

Reconcile the drift so the file matches your `.tf` configuration again:

```bash
terraform apply -auto-approve
cat files/config_b.txt
```

- ✅ Confirm the file content has been restored to match `main.tf`
- 🔁 This demonstrates Terraform's core reconciliation loop: **desired state wins**

### Task 6: 📊 Inspect State with CLI Commands

Run each command and record the output:

```bash
# List all resources tracked in state
terraform state list

# Show detailed attributes for one resource
terraform state show local_file.config_a
```

- 🔎 Compare the attributes shown here to what you saw in `terraform.tfstate` directly
- 🔎 Identify at least 3 attributes shown by `state show` that are **NOT** visible by simply looking at the file content (e.g., `id`, `content_base64sha256`)

### Task 7: 🗑️ Remove a Resource from State

Remove `config_c` from Terraform's state **without deleting the actual file**:

```bash
terraform state rm local_file.config_c
terraform state list
```

**Now run:**

```bash
terraform plan
```

> 👀 **Observe:** Terraform now proposes to create `config_c` again, because it's still declared in `main.tf` but no longer tracked in state.

**Check the file still exists on disk:**

```bash
ls files/config_c.txt
```

> 🛠️ **Troubleshooting tip:** If apply fails with a "file already exists" type conflict, this is expected — it illustrates why `state rm` should be paired with either updating configuration or re-importing the resource (`terraform import`) rather than blindly re-applying.

---

## 🔑 Key Concepts

| Concept | Description |
|---|---|
| **State file (`terraform.tfstate`)** | Terraform's record of the resources it manages and their last-known attributes |
| **Configuration drift** | When real-world infrastructure diverges from what's declared in `.tf` files |
| **`terraform plan`** | Compares desired state (config) against tracked state to surface drift or pending changes |
| **Desired-state reconciliation** | Terraform's core loop: `apply` pushes real infrastructure back in line with configuration |
| **`terraform state list`** | Lists all resources currently tracked in state |
| **`terraform state show`** | Displays the full recorded attributes of a single tracked resource |
| **`terraform state rm`** | Stops tracking a resource in state without touching the real-world object |
| **`terraform import`** | Brings an existing real-world object back under Terraform's state tracking |

## ✅ Verification

Confirm lab completion by checking:

- [ ] `terraform.tfstate` exists and contains 3 resource entries (before Task 7) or 2 (after Task 7)
- [ ] `files/config_b.txt` content matches `main.tf` after Task 5 (drift reconciled)
- [ ] `terraform state list` output correctly reflects removals/additions at each stage
- [ ] `terraform state show local_file.config_a` returns detailed JSON-like attributes
- [ ] `terraform plan` after Task 7 shows a pending "create" action for `config_c`

**Run a final check:**

```bash
terraform state list
terraform plan
```

## 🏁 Conclusion

In this lab, you built a Terraform project using the local provider and explored how Terraform tracks infrastructure through its state file. You simulated real-world configuration drift by editing a managed file outside of Terraform, then used `terraform plan` to detect the discrepancy and `terraform apply` to reconcile it — reinforcing Terraform's core desired-state model. You also practiced essential state inspection and management commands (`state list`, `state show`, `state rm`), and observed how removing a resource from state (without deleting the underlying object) causes Terraform to plan a duplicate creation.

**🎯 Key Accomplishments:**
- ✅ Provisioned and inspected a Terraform-managed state file
- ✅ Simulated and detected configuration drift with `terraform plan`
- ✅ Reconciled drift by re-applying desired-state configuration
- ✅ Practiced `state list`, `state show`, and `state rm` for state management
- ✅ Observed the consequences of untracked resources still declared in config

**🌍 Real-World Applications:**
These skills are directly applicable to real-world DevOps and SRE workflows involving drift detection, state troubleshooting, and safe state manipulation — all core competencies for the HashiCorp Certified: Terraform Associate exam.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
