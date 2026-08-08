<div align="center">

# 🧱 Build Reusable Terraform Modules

![Terraform](https://img.shields.io/badge/Terraform-Modules-844FBA?style=for-the-badge&logo=terraform&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Ubuntu%2FDebian-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Modules](https://img.shields.io/badge/Focus-Reusable%20Modules-0052CC?style=for-the-badge)
![Difficulty](https://img.shields.io/badge/Difficulty-Intermediate-orange?style=for-the-badge)
![Provider](https://img.shields.io/badge/Provider-Local-0052CC?style=for-the-badge)

**Build a parameterized child module, call it multiple times, and wire outputs through the root configuration**

</div>

---

## 📑 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Environment Setup](#️-environment-setup)
- [🧩 Tasks](#-tasks)
  - [Task 1: 🏗️ Build the Child Module](#task-1-🏗️-build-the-child-module)
  - [Task 2: 🌳 Build the Root Configuration](#task-2-🌳-build-the-root-configuration)
  - [Task 3: 📤 Expose Module Outputs at Root Level](#task-3-📤-expose-module-outputs-at-root-level)
  - [Task 4: 🚀 Initialize, Plan, and Apply](#task-4-🚀-initialize-plan-and-apply)
  - [Task 5: 🛠️ Troubleshooting Checklist](#task-5-️-troubleshooting-checklist)
- [🔑 Key Concepts](#-key-concepts)
- [✅ Verification](#-verification)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

| # | Objective |
|---|-----------|
| 1 | Create a reusable Terraform child module with `main.tf`, `variables.tf`, `outputs.tf` |
| 2 | Pass parameters into modules using input variables |
| 3 | Retrieve and use module outputs in a root configuration |
| 4 | Call the same module multiple times with different inputs |
| 5 | Deploy and verify modular infrastructure using `init`, `plan`, `apply` |

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| Terraform syntax | Basic understanding (resources, providers, variables) |
| Linux terminal | Familiarity with commands |
| Local provider | Prior exposure helpful but not required |

## 🖥️ Environment Setup

> Al Nafi provides a single Linux machine via Start Lab. Use it directly.

**1️⃣ Verify/install Terraform:**

```bash
terraform -version
```

**2️⃣ If not installed:**

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform -y
```

**3️⃣ Create project structure:**

```bash
mkdir -p ~/tf-modules-lab/modules/file-creator
cd ~/tf-modules-lab
```

---

## 🧩 Tasks

### Task 1: 🏗️ Build the Child Module

**1️⃣ Navigate to the module directory:**

```bash
cd ~/tf-modules-lab/modules/file-creator
```

**2️⃣ Create `variables.tf`** — define inputs for filename and content:

```hcl
variable "filename" {
  description = "Path/name of the file to create"  # 📄 required input
  type        = string
}

variable "content" {
  description = "Content to write into the file"  # ✍️ required input
  type        = string
  # TODO: add a sensible default value
}

variable "file_permission" {
  description = "Permission bits for the file"  # 🔐 optional input
  type        = string
  default     = "0644"
}
```

**3️⃣ Create `main.tf`** — define the resource using the local provider:

```hcl
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"  # 🔌 official local provider
      version = "~> 2.4"
    }
  }
}

resource "local_file" "this" {
  # TODO: set filename argument using var.filename
  # TODO: set content argument using var.content
  # TODO: set file_permission argument using var.file_permission
}
```

**4️⃣ Create `outputs.tf`** — expose useful attributes:

```hcl
output "file_path" {
  description = "Path of the created file"  # 📤 output #1
  value       = local_file.this.filename
}

output "file_id" {
  description = "Terraform resource ID of the file"  # 🆔 output #2
  value       = local_file.this.id
}

# TODO: add an output "content_md5" that exposes local_file.this.content_md5
```

### Task 2: 🌳 Build the Root Configuration

**1️⃣ Move to the project root:**

```bash
cd ~/tf-modules-lab
```

**2️⃣ Create root `main.tf`. Call the module twice with different parameters:**

```hcl
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"  # 🔌 official local provider
      version = "~> 2.4"
    }
  }
}

module "readme_file" {
  source   = "./modules/file-creator"  # 📦 module call #1
  filename = "${path.module}/output/README.txt"
  content  = "This file was created by Terraform module 1."
}

module "config_file" {
  source          = "./modules/file-creator"  # 📦 module call #2
  filename        = "${path.module}/output/app.conf"
  content         = "env=production\nversion=1.0"
  # TODO: pass a custom file_permission value, e.g. "0600"
}
```

### Task 3: 📤 Expose Module Outputs at Root Level

Create root `outputs.tf`:

```hcl
output "readme_path" {
  value = module.readme_file.file_path  # 📄 from module call #1
}

output "config_path" {
  value = module.config_file.file_path  # 📄 from module call #2
}

# TODO: add an output that displays module.config_file.content_md5
```

### Task 4: 🚀 Initialize, Plan, and Apply

Run the standard Terraform workflow:

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

**Expected behavior:**
- ⚙️ Terraform initializes the local provider and discovers the child module
- 🔍 Plan shows 2 resources to add (one per module call)
- 🚀 Apply creates `output/README.txt` and `output/app.conf`

### Task 5: 🛠️ Troubleshooting Checklist

<details>
<summary><strong>🔧 Click to expand common issues and fixes</strong></summary>

<br>

| Issue | Fix |
|---|---|
| `Error: Module not installed` | Run `terraform init` again after any module source path change |
| Permission denied writing file | Ensure `output/` directory is writable; Terraform creates it automatically via `local_file`, but check parent directory permissions |
| Output shows `(known after apply)` for `content_md5` | Expected during plan; resolves after apply |
| Changing module inputs has no effect | Confirm you saved the file and re-run `terraform plan` |

</details>

---

## 🔑 Key Concepts

| Concept | Description |
|---|---|
| **Child module** | A self-contained Terraform configuration (its own `main.tf`/`variables.tf`/`outputs.tf`) meant to be called by another configuration |
| **Root configuration** | The top-level Terraform configuration that calls one or more modules |
| **`module` block** | Declares a call to a child module, passing inputs via arguments matching its declared variables |
| **Module output** | A value a child module exposes via `output`, accessed from the root as `module.<name>.<output>` |
| **Reusability** | The same module source can be called multiple times with different inputs to produce distinct resources |
| **`terraform state list`** | Shows tracked resources with their module path prefix (e.g. `module.readme_file.local_file.this`) |

## ✅ Verification

**1️⃣ Confirm files were created:**

```bash
cat output/README.txt
cat output/app.conf
```

**2️⃣ Check permission bits on `app.conf` match your custom setting:**

```bash
stat -c "%a %n" output/app.conf
```

**3️⃣ Display outputs from state:**

```bash
terraform output
```

**4️⃣ Confirm module reusability by inspecting state resources:**

```bash
terraform state list
```

**Expected entries:**
- `module.readme_file.local_file.this`
- `module.config_file.local_file.this`

**5️⃣ Clean up when done:**

```bash
terraform destroy -auto-approve
```

## 🏁 Conclusion

In this lab, you built a reusable Terraform child module encapsulating a `local_file` resource with parameterized inputs (`filename`, `content`, `file_permission`) and defined outputs to expose resource details. You referenced this module twice from a root configuration, passing distinct parameters into each call, demonstrating true module reusability. You then wired module outputs into root-level outputs and validated the entire deployment using `terraform init`, `plan`, and `apply`.

**🎯 Key Accomplishments:**
- ✅ Built a parameterized child module with its own variables, resource, and outputs
- ✅ Called the same module twice with different input values
- ✅ Wired child-module outputs into root-level outputs
- ✅ Verified modular resources and outputs via `terraform state list` and `terraform output`

**🌍 Real-World Applications:**
This pattern of building small, composable modules mirrors real-world DevOps and Cloud Architect workflows, and directly supports the module-related objectives of the HashiCorp Certified: Terraform Associate exam.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
