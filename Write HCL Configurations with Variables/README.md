<div align="center">

# 🔤 Write HCL Configurations with Variables

![Terraform](https://img.shields.io/badge/Terraform-1.9.0-844FBA?style=for-the-badge&logo=terraform&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Ubuntu%2FDebian-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![HCL](https://img.shields.io/badge/HCL-Variables%20%26%20Outputs-844FBA?style=for-the-badge)
![Difficulty](https://img.shields.io/badge/Difficulty-Beginner-brightgreen?style=for-the-badge)
![Provider](https://img.shields.io/badge/Provider-Local-0052CC?style=for-the-badge)

**Learn to parameterize Infrastructure as Code with HCL input variables, tfvars, and outputs**

</div>

---

## 📑 Table of Contents

- [🎯 Learning Objectives](#-learning-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Environment Setup](#️-environment-setup)
- [🧩 Tasks](#-tasks)
  - [Task 1: 📁 Create the Project Directory](#task-1-📁-create-the-project-directory)
  - [Task 2: 🔤 Define Input Variables](#task-2-🔤-define-input-variables)
  - [Task 3: 📝 Create terraform.tfvars to Override Defaults](#task-3-📝-create-terraformtfvars-to-override-defaults)
  - [Task 4: ⚙️ Write main.tf Using the Local Provider](#task-4-️-write-maintf-using-the-local-provider)
  - [Task 5: 📤 Define Outputs](#task-5-📤-define-outputs)
  - [Task 6: 🚀 Initialize, Plan, and Apply](#task-6-🚀-initialize-plan-and-apply)
  - [Task 7: 🔄 Modify a Variable and Re-Apply](#task-7-🔄-modify-a-variable-and-re-apply)
- [🔑 Key Concepts](#-key-concepts)
- [✅ Verification](#-verification)
- [🛠️ Troubleshooting Tips](#️-troubleshooting-tips)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Learning Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | Write basic HCL (HashiCorp Configuration Language) syntax in Terraform files |
| 2 | Define input variables with string, number, and list data types |
| 3 | Use a `terraform.tfvars` file to supply and override variable values |
| 4 | Reference variables inside resource blocks to generate dynamic content |
| 5 | Define and display output values after running `terraform apply` |
| 6 | Observe how Terraform detects and applies changes when variables are modified |

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| Linux terminal familiarity | Navigating folders, editing files |
| Terraform experience | None required |
| Text editor | Available on the machine (e.g., `nano` or `vim`) |

## 🖥️ Environment Setup

> This lab uses a single Linux machine provided via Start Lab. No cloud account or credit card is required — we use Terraform's **local provider** only.

**1️⃣ Open a terminal on your lab machine.**

**2️⃣ Install Terraform (skip if already installed):**

```bash
sudo apt-get update
sudo apt-get install -y wget unzip
wget https://releases.hashicorp.com/terraform/1.9.0/terraform_1.9.0_linux_amd64.zip
unzip terraform_1.9.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform -version
```

> ✅ Confirm output shows a Terraform version (e.g., `Terraform v1.9.0`).

---

## 🧩 Tasks

### Task 1: 📁 Create the Project Directory

```bash
mkdir ~/hcl-variables-lab
cd ~/hcl-variables-lab
touch main.tf variables.tf terraform.tfvars outputs.tf
```

| File | Purpose |
|---|---|
| `main.tf` | 🏗️ main configuration (resources) |
| `variables.tf` | 🔤 variable declarations |
| `terraform.tfvars` | 📝 variable values |
| `outputs.tf` | 📤 output definitions |

### Task 2: 🔤 Define Input Variables

Open `variables.tf` and add the following. Each variable shows a different data type.

```hcl
# variables.tf

# A string variable with a default value
variable "student_name" {
  description = "Name of the student"  # 🧑 who this config is for
  type        = string
  default     = "guest"
}

# A number variable with a default value
variable "file_count" {
  description = "Number of lines to write in the file"  # 🔢 numeric type
  type        = number
  default     = 1
}

# A list variable with default values
variable "course_topics" {
  description = "List of topics covered in this course"  # 📚 list type
  type        = list(string)
  default     = ["HCL", "Terraform", "Variables"]
}
```

### Task 3: 📝 Create terraform.tfvars to Override Defaults

Edit `terraform.tfvars`:

```hcl
# terraform.tfvars
# These values override the defaults set in variables.tf

student_name  = "Ahmed"          # 🧑 overrides default "guest"
file_count    = 3                # 🔢 overrides default 1
course_topics = ["HCL", "Terraform", "IaC", "DevOps"]  # 📚 overrides default list
```

### Task 4: ⚙️ Write main.tf Using the Local Provider

Add this to `main.tf`. It creates a local text file whose content is built from your variables.

```hcl
# main.tf

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"  # 🔌 official local provider
      version = "~> 2.5"
    }
  }
}

# The local_file resource writes content to a file on disk
resource "local_file" "student_info" {
  filename = "${path.module}/student_output.txt"  # 📄 output file path

  # TODO: Use string interpolation to combine variables into one string
  # Hint: use join() to convert the list into a comma-separated string
  content = <<-EOT
    Student Name: ${var.student_name}
    Number of Files Requested: ${var.file_count}
    Topics Covered: ${join(", ", var.course_topics)}
  EOT
}
```

### Task 5: 📤 Define Outputs

Edit `outputs.tf`:

```hcl
# outputs.tf

# Displays the path of the created file after apply
output "file_path" {
  description = "Path to the generated file"  # 📄 output #1
  value       = local_file.student_info.filename
}

# Displays the student name used
output "student_name_output" {
  description = "Name of the student used in the configuration"  # 🧑 output #2
  value       = var.student_name
}

# TODO: Add one more output that displays the course_topics list
```

### Task 6: 🚀 Initialize, Plan, and Apply

Run the following commands in order:

```bash
terraform init
terraform plan
terraform apply
```

Type `yes` when prompted to confirm apply.

**Check the result:**

```bash
cat student_output.txt
```

> ✅ You should see your name, file count, and topics list printed inside the file.

### Task 7: 🔄 Modify a Variable and Re-Apply

**1️⃣ Open `terraform.tfvars` and change one value, for example:**

```hcl
student_name = "Fatima"
file_count   = 5
```

**2️⃣ Run plan again to see what will change:**

```bash
terraform plan
```

> 🔎 Notice Terraform shows the file will be updated in-place (since `content` changes).

**3️⃣ Apply the change:**

```bash
terraform apply
```

**4️⃣ Verify the file content updated:**

```bash
cat student_output.txt
```

---

## 🔑 Key Concepts

| Concept | Description |
|---|---|
| **Input variable** | A parameter (`variable` block) that lets a configuration accept external values instead of hardcoding them |
| **`terraform.tfvars`** | A file Terraform automatically loads to override variable defaults with custom values |
| **Variable types** | HCL supports typed variables such as `string`, `number`, and `list(string)` |
| **String interpolation** | `${var.name}` syntax used to embed variable values inside strings |
| **`join()`** | A built-in function that converts a list into a single delimited string |
| **Output value** | An `output` block that surfaces a value after `apply`, viewable via `terraform output` |
| **In-place update** | When a changed attribute (like `content`) doesn't require replacing the resource, Terraform updates it directly |

## ✅ Verification

Confirm your lab is complete by checking:

- [ ] `variables.tf` contains three variables of type `string`, `number`, and `list`
- [ ] `terraform.tfvars` overrides all three default values
- [ ] `terraform apply` runs successfully with no errors
- [ ] `student_output.txt` exists and contains variable-driven content
- [ ] `terraform output` command displays your defined outputs:
  ```bash
  terraform output
  ```
- [ ] After changing a variable and re-applying, `student_output.txt` reflects the new values

## 🛠️ Troubleshooting Tips

<details>
<summary><strong>🔧 Click to expand common issues and fixes</strong></summary>

<br>

| Issue | Fix |
|---|---|
| `Error: provider not found` | Run `terraform init` again to download the local provider |
| Variable value not applying | Ensure `terraform.tfvars` is in the same directory as `main.tf` (Terraform loads it automatically) |
| Syntax errors in HCL | Check for missing quotes, brackets, or curly braces; run `terraform validate` to catch mistakes |
| File not created | Confirm you ran `terraform apply` and typed `yes` to confirm |
| Permission denied | Ensure you have write access to the project directory (`ls -l` to check permissions) |

</details>

## 🏁 Conclusion

In this lab, you learned the fundamentals of writing HCL configurations using Terraform's local provider. You created and organized a Terraform project into `main.tf`, `variables.tf`, `terraform.tfvars`, and `outputs.tf` files. You defined input variables using string, number, and list data types, supplied custom values through a `.tfvars` file, and referenced those variables inside a resource block to dynamically generate file content. You also defined output values to display key information after applying your configuration, and observed how Terraform detects and applies changes when variable values are modified.

**🎯 Key Accomplishments:**
- ✅ Wrote HCL variable declarations across `string`, `number`, and `list` types
- ✅ Overrode default values with a `terraform.tfvars` file
- ✅ Generated dynamic file content via string interpolation and `join()`
- ✅ Defined and viewed output values with `terraform output`
- ✅ Observed Terraform's in-place update behavior after a variable change

**🌍 Real-World Applications:**
These skills form the foundation for writing reusable, parameterized Infrastructure as Code configurations — a core competency for the HashiCorp Certified: Terraform Associate exam and real-world DevOps/Infrastructure Engineer roles.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
