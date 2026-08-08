<div align="center">

# 🏗️ Install and Configure Terraform on Linux

![Terraform](https://img.shields.io/badge/Terraform-1.9.5-844FBA?style=for-the-badge&logo=terraform&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Ubuntu%2FDebian-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![IaC](https://img.shields.io/badge/Infrastructure-as%20Code-2496ED?style=for-the-badge&logo=googlecloud&logoColor=white)
![Difficulty](https://img.shields.io/badge/Difficulty-Beginner-brightgreen?style=for-the-badge)
![Provider](https://img.shields.io/badge/Provider-Local-0052CC?style=for-the-badge)

**A hands-on introduction to installing Terraform and running the core Infrastructure-as-Code workflow**

</div>

---

## 📑 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment](#️-lab-environment)
- [🧩 Tasks](#-tasks)
  - [Task 1: 📥 Download and Install Terraform](#task-1-📥-download-and-install-terraform)
  - [Task 2: ✅ Verify the Installation](#task-2-✅-verify-the-installation)
  - [Task 3: 📝 Create a Project Directory and Write main.tf](#task-3-📝-create-a-project-directory-and-write-maintf)
  - [Task 4: ⚙️ Initialize the Working Directory](#task-4-️-initialize-the-working-directory)
  - [Task 5: 🔍 Preview Changes with terraform plan](#task-5-🔍-preview-changes-with-terraform-plan)
  - [Task 6: 🚀 Apply the Configuration](#task-6-🚀-apply-the-configuration)
  - [Task 7: 🧹 Destroy the Resource](#task-7-🧹-destroy-the-resource)
- [🔑 Key Concepts](#-key-concepts)
- [✅ Verification](#-verification)
- [🛠️ Troubleshooting Tips](#️-troubleshooting-tips)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | Install Terraform on a Linux machine and add it to the system PATH |
| 2 | Verify the Terraform installation using CLI commands |
| 3 | Write a basic Terraform configuration file using the local provider |
| 4 | Understand and execute the core Terraform workflow: `init`, `plan`, `apply`, `destroy` |

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| Linux terminal familiarity | Navigating directories, running commands |
| Terraform experience | None required |
| Text editor | `nano`, `vim`, or any editor available on the machine |

## 🖥️ Lab Environment

> **Environment Setup**
> - This lab uses a single Linux machine (provided via Al Nafi Start Lab)
> - No cloud provider account is required — this lab uses Terraform's **local provider** only
> - Ensure you have internet access to download the Terraform binary and provider plugin

---

## 🧩 Tasks

### Task 1: 📥 Download and Install Terraform

**1️⃣ Update package lists and install required utilities:**

```bash
sudo apt-get update
sudo apt-get install -y wget unzip
```

**2️⃣ Download the Terraform binary** *(check terraform.io for the latest version if needed)*:

```bash
wget https://releases.hashicorp.com/terraform/1.9.5/terraform_1.9.5_linux_amd64.zip
```

**3️⃣ Unzip the downloaded file:**

```bash
unzip terraform_1.9.5_linux_amd64.zip
```

**4️⃣ Move the binary into your system PATH:**

```bash
sudo mv terraform /usr/local/bin/
```

**5️⃣ Confirm the binary is executable:**

```bash
sudo chmod +x /usr/local/bin/terraform
```

> 💡 **Note:** `/usr/local/bin` is already part of the default PATH on most Linux distributions. Verify with `echo $PATH`.

### Task 2: ✅ Verify the Installation

**1️⃣ Check the installed Terraform version:**

```bash
terraform --version
# ✅ Expected output: Terraform v1.9.5
```

**2️⃣ Explore the built-in help system:**

```bash
terraform --help
```

**3️⃣ View help for a specific command:**

```bash
terraform plan --help
```

### Task 3: 📝 Create a Project Directory and Write main.tf

**1️⃣ Create a new directory for your Terraform project:**

```bash
mkdir ~/terraform-lab
cd ~/terraform-lab
```

**2️⃣ Create a file named `main.tf`:**

```bash
nano main.tf
```

**3️⃣ Add the following configuration.** This uses the local provider to create a text file on your machine — no cloud account needed.

```hcl
# main.tf
# This block tells Terraform which provider to use
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"  # 🔌 official local provider
      version = "~> 2.5"           # 📌 provider version constraint
    }
  }
}

# This block configures the local provider (no settings needed)
provider "local" {}

# This resource creates a simple text file on disk
resource "local_file" "my_first_file" {
  filename = "${path.module}/hello.txt"   # 📄 file path (in the same folder)
  content  = "Hello from Terraform! This file was created by IaC.\n"  # ✍️ file content
}
```

**4️⃣ Save and exit** *(in nano: `Ctrl+O`, `Enter`, then `Ctrl+X`)*

### Task 4: ⚙️ Initialize the Working Directory

**1️⃣ Run the init command to download the local provider plugin:**

```bash
terraform init
```

**What this does:**
- 📖 Reads your `main.tf` file
- ⬇️ Downloads the `hashicorp/local` provider plugin
- 📁 Creates a `.terraform` directory and a lock file (`.terraform.lock.hcl`)

> ✅ **Expected output:** `Terraform has been successfully initialized!`

### Task 5: 🔍 Preview Changes with terraform plan

**1️⃣ Run the plan command:**

```bash
terraform plan
```

**What to look for in the output:**
- ➕ A `+` sign next to `local_file.my_first_file` means Terraform will create this resource
- 🔎 Review the `filename` and `content` attributes shown in the plan
- 🚫 No changes are made to your system yet — this is only a preview

### Task 6: 🚀 Apply the Configuration

**1️⃣ Run the apply command:**

```bash
terraform apply
```

**2️⃣ Terraform will show the plan again and prompt for confirmation. Type:**

```bash
yes
```

**3️⃣ Confirm the file was created:**

```bash
ls -l
cat hello.txt
```

> ✅ **Expected output:** `hello.txt` exists and contains the text `"Hello from Terraform!..."`

**4️⃣ Inspect the state file Terraform created to track the resource:**

```bash
cat terraform.tfstate
```

### Task 7: 🧹 Destroy the Resource

**1️⃣ Run the destroy command to remove the resource:**

```bash
terraform destroy
```

Type `yes` when prompted to confirm.

**2️⃣ Verify the file was removed:**

```bash
ls -l
# ✅ Expected output: hello.txt should no longer be listed
```

---

## 🔑 Key Concepts

| Concept | Description |
|---|---|
| **Provider** | A plugin (e.g. `hashicorp/local`) that lets Terraform manage a specific set of resources |
| **`terraform init`** | Initializes the working directory and downloads required provider plugins |
| **`terraform plan`** | Previews the changes Terraform will make, without applying them |
| **`terraform apply`** | Executes the plan and provisions/updates the actual resources |
| **`terraform destroy`** | Tears down resources that Terraform is tracking |
| **State file (`terraform.tfstate`)** | Tracks the real-world resources Terraform manages and their current attributes |
| **Local provider** | Lets you practice core Terraform workflows without needing a cloud account |

## ✅ Verification

Confirm the lab is complete by checking:

| Step | Command | Expected Result |
|---|---|---|
| Install | `terraform --version` | Shows installed version number |
| Init | `terraform init` | "successfully initialized" message |
| Plan | `terraform plan` | Shows `+ create` for `local_file` resource |
| Apply | `terraform apply` | `hello.txt` file exists with correct content |
| Destroy | `terraform destroy` | `hello.txt` file no longer exists |

## 🛠️ Troubleshooting Tips

<details>
<summary><strong>🔧 Click to expand common issues and fixes</strong></summary>

<br>

| Issue | Fix |
|---|---|
| `terraform: command not found` | Double-check the binary was moved to `/usr/local/bin` and is executable (`chmod +x`) |
| `Error: Failed to query available provider packages` | Check your internet connection; the local provider must be downloaded during `init` |
| Permission denied errors | Ensure you have write permissions in your project directory (avoid running as root unless necessary) |
| `main.tf` syntax errors | Terraform configuration is sensitive to braces `{}` and indentation; compare carefully with the provided template |
| Old state blocking destroy | If `terraform destroy` fails, ensure you are in the same directory where `terraform apply` was run (state file must be present) |

</details>

## 🏁 Conclusion

In this lab, you installed Terraform on a Linux machine and added it to your system PATH, then verified the installation using CLI commands. You created a minimal Terraform configuration using the local provider and walked through the complete core workflow: initializing the working directory with `init`, previewing changes with `plan`, provisioning a local file resource with `apply`, and cleaning up with `destroy`.

**🎯 Key Accomplishments:**
- ✅ Installed and configured the Terraform CLI on Linux
- ✅ Verified the installation and explored the built-in help system
- ✅ Wrote a working Terraform configuration using the local provider
- ✅ Executed the full `init` → `plan` → `apply` → `destroy` workflow

**🌍 Real-World Applications:**
These fundamentals — writing configuration files, understanding provider plugins, and following the init-plan-apply-destroy cycle — form the foundation for all Infrastructure as Code work with Terraform, regardless of which provider (AWS, Azure, GCP, or local) you use in future labs.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
