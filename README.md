# 🚀 Infrastructure as Code (IaC)

<p align="center">
  <img src="https://img.shields.io/badge/Infrastructure-as--Code-blue?style=for-the-badge&logo=terraform" alt="Infrastructure as Code">
  <img src="https://img.shields.io/badge/Terraform-IaC-purple?style=for-the-badge&logo=terraform" alt="Terraform">
  <img src="https://img.shields.io/badge/Ansible-Automation-red?style=for-the-badge&logo=ansible" alt="Ansible">
  <img src="https://img.shields.io/badge/Vault-Secrets-black?style=for-the-badge&logo=vault" alt="HashiCorp Vault">
  <img src="https://img.shields.io/badge/Docker-Containers-blue?style=for-the-badge&logo=docker" alt="Docker">
  <img src="https://img.shields.io/badge/GitLab-CI/CD-orange?style=for-the-badge&logo=gitlab" alt="GitLab CI">
</p>

<p align="center">
  <b>Infrastructure Automation • Configuration Management • Secrets Management • CI/CD</b>
</p>

---

## 📌 About This Repository

This repository is dedicated to **Infrastructure as Code (IaC)** practices and automation.

It is part of the **Al-Razzaq Programme** and contains practical labs, exercises, configurations, automation scripts, and infrastructure engineering tasks designed to build hands-on experience with modern IaC and DevOps technologies.

The main purpose of this repository is to demonstrate how infrastructure and operational environments can be:

* ⚙️ Automated
* 🔄 Reproduced consistently
* 📦 Version controlled
* 🔐 Secured
* 🧩 Modularized
* 🚀 Integrated into CI/CD pipelines
* 📚 Documented as code

Instead of manually configuring infrastructure, this repository follows the principle of defining infrastructure and operational configuration in **declarative, version-controlled code**.

---

# 🎯 Repository Purpose

The primary purpose of this repository is to develop practical expertise in **Infrastructure as Code and infrastructure automation**.

It provides hands-on experience with tools and practices used by modern Cloud, DevOps, Platform Engineering, and Infrastructure teams.

The repository focuses on the complete IaC workflow:

```text
┌───────────────────────────────┐
│       Infrastructure          │
│          Requirements         │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│       Infrastructure as       │
│             Code              │
│    Terraform / HCL / YAML     │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│        Configuration &        │
│          Automation            │
│          Ansible              │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│       Secrets Management      │
│        HashiCorp Vault        │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│       Containerized IaC       │
│            Docker             │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│       CI/CD Automation        │
│          GitLab CI            │
└───────────────────────────────┘
```

---

# 🧠 What This Repository Demonstrates

## 🏗️ Infrastructure Provisioning

Terraform is used to understand and implement declarative infrastructure provisioning.

Key concepts include:

* Terraform installation and configuration
* HCL syntax
* Variables
* Infrastructure resources
* Terraform modules
* Reusable infrastructure components
* Terraform state
* State management
* Infrastructure drift detection

---

## 🧩 Reusable Terraform Modules

The repository includes practical work around building reusable Terraform modules.

The goal is to move from:

```text
One-off Terraform configuration
```

toward:

```text
Reusable Infrastructure Modules
```

A reusable module can be represented as:

```text
Terraform Root Module
        │
        ├── Variables
        │
        ▼
   Reusable Module
        │
        ├── Resources
        ├── Configuration
        └── Outputs
```

This approach improves:

* Reusability
* Maintainability
* Consistency
* Scalability
* Team collaboration

---

# 🔐 Secrets Management with HashiCorp Vault

Infrastructure automation frequently requires sensitive information such as:

* Database credentials
* API keys
* Passwords
* Tokens
* Service credentials

This repository includes practical work with **HashiCorp Vault** for managing infrastructure secrets securely.

Example hierarchy:

```text
secret/
├── database/
│   └── prod
│
└── api/
    └── external-service
```

This demonstrates the principle of keeping secrets separate from infrastructure source code.

---

# ⚙️ Configuration Management with Ansible

Ansible is used to explore configuration management and automation.

The repository includes practical work such as:

* Installing Ansible
* Writing Ansible playbooks
* Automating configuration
* Managing infrastructure systems
* Reproducing configuration consistently

Example workflow:

```text
Ansible Controller
       │
       ├──────────────┐
       │              │
       ▼              ▼
   Linux Host 1    Linux Host 2
       │              │
       └──────┬───────┘
              ▼
       Consistent Configuration
```

---

# 🐳 Containerized IaC Tooling

Docker is used to understand how Infrastructure as Code tools can be packaged into reproducible environments.

Containerizing IaC tooling can help provide:

* Consistent environments
* Dependency isolation
* Reproducibility
* Easier onboarding
* Portable automation workflows

The repository includes practical work related to creating Dockerfiles for IaC tooling.

---

# 🔄 CI/CD for Infrastructure

Infrastructure code should be treated similarly to application code.

This repository explores automation using **GitLab CI/CD**.

A typical workflow is:

```text
Developer
    │
    ▼
Git Repository
    │
    ▼
GitLab CI
    │
    ├── Validate
    ├── Format
    ├── Plan
    ├── Test
    └── Apply
            │
            ▼
     Infrastructure
```

This helps establish automated infrastructure delivery and reduces manual operational tasks.

---

# 📊 Terraform State & Drift Detection

Terraform state is a critical part of infrastructure management.

This repository explores:

* Terraform state
* State management
* Infrastructure changes
* Drift detection
* Comparing declared infrastructure with actual infrastructure

Conceptually:

```text
Terraform Configuration
          │
          ▼
     Terraform State
          │
          ▼
 Actual Infrastructure
          │
          ▼
       Drift Check
```

This helps identify situations where infrastructure has changed outside Terraform.

---

# 📝 Infrastructure Documentation

Infrastructure should not only be automated; it should also be understandable.

This repository includes work related to documenting infrastructure using:

* DSL-based infrastructure descriptions
* Diagrams
* README documentation
* Configuration explanations
* Architecture representation

The goal is to make infrastructure easier to understand, maintain, and communicate.

---

# 🛠️ Technologies & Tools

<p align="center">

<img src="https://img.shields.io/badge/Terraform-844FBA?style=for-the-badge&logo=terraform&logoColor=white">
<img src="https://img.shields.io/badge/Ansible-EE0000?style=for-the-badge&logo=ansible&logoColor=white">
<img src="https://img.shields.io/badge/Vault-000000?style=for-the-badge&logo=vault&logoColor=white">
<img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white">
<img src="https://img.shields.io/badge/GitLab_CI-FC6D26?style=for-the-badge&logo=gitlab&logoColor=white">

</p>

Additional technologies and concepts:

* 🏗️ Infrastructure as Code
* ☁️ Cloud Infrastructure
* 🐧 Linux
* 🔧 HCL
* 📝 YAML
* 🔐 Secrets Management
* 🔄 CI/CD
* 📦 Containers
* 📊 State Management
* 🧩 Modular Infrastructure
* 📚 Infrastructure Documentation

---
# 🎓 Learning Objectives

By working through this repository, the learner develops the ability to:

### Infrastructure

* Understand Infrastructure as Code principles
* Write Terraform configurations
* Work with HCL
* Use Terraform variables
* Build reusable modules
* Understand Terraform state

### Automation

* Automate infrastructure workflows
* Use Ansible for configuration management
* Build repeatable operational processes

### Security

* Manage infrastructure secrets
* Understand Vault KV secrets
* Separate credentials from source code
* Apply better secret-management practices

### Containers

* Package IaC tooling using Docker
* Build reproducible tooling environments
* Understand containerized infrastructure workflows

### CI/CD

* Automate infrastructure validation
* Integrate IaC with GitLab CI/CD
* Build repeatable infrastructure pipelines

### Documentation

* Document infrastructure
* Create architecture diagrams
* Explain infrastructure designs clearly

---

# 🔄 IaC Lifecycle

This repository demonstrates an overall Infrastructure as Code lifecycle:

```text
        PLAN
          │
          ▼
     CODE INFRA
          │
          ▼
      VALIDATE
          │
          ▼
        PLAN
          │
          ▼
        APPLY
          │
          ▼
      MONITOR
          │
          ▼
   DETECT DRIFT
          │
          ▼
       UPDATE
          │
          └──────────────► REPEAT
```

---

# 🔒 Security Principles

Security is an important part of infrastructure automation.

This repository promotes practices such as:

* ❌ Do not hard-code production passwords
* ❌ Do not commit API keys
* ❌ Do not commit private credentials
* ❌ Do not expose Vault root tokens
* ✅ Use secret-management systems
* ✅ Use least-privilege access
* ✅ Protect Terraform state
* ✅ Review infrastructure changes
* ✅ Keep sensitive files out of Git

A suitable `.gitignore` should be used to prevent accidental credential exposure.

Example:

```gitignore
# Terraform
.terraform/
*.tfstate
*.tfstate.*
*.tfvars

# Sensitive files
.env
*.pem
*.key
secrets/
credentials/

# Vault
vault-data/
```

---

# 🚀 Getting Started

Clone the repository:

```bash
git clone https://github.com/msalman199/-Infrastructure-as-Code-IaC-.git
```

Enter the repository:

```bash
cd -Infrastructure-as-Code-IaC-
```

Review the available labs:

```bash
ls -la
```

Enter the relevant lab directory and follow its individual documentation.

---

# 📚 Recommended Workflow

For each lab:

```text
1. Read the objectives
        ↓
2. Review prerequisites
        ↓
3. Configure required tools
        ↓
4. Execute the lab
        ↓
5. Validate the result
        ↓
6. Document what was learned
        ↓
7. Commit changes to Git
```

---

# 🌟 Why Infrastructure as Code?

Traditional infrastructure management can involve manually configuring servers and environments.

This can lead to:

```text
Manual Configuration
       │
       ├── Human Error
       ├── Configuration Drift
       ├── Difficult Reproduction
       └── Slow Deployment
```

IaC changes this model:

```text
Infrastructure Code
       │
       ├── Version Control
       ├── Automation
       ├── Reproducibility
       ├── Reviewability
       └── Consistency
```

Infrastructure becomes something that can be **created, reviewed, tested, versioned, and reproduced using code**.

---

# 🏆 Programme

This repository is part of the **Al-Razzaq Programme** and serves as a practical collection of Infrastructure as Code learning activities and implementation exercises.

---

# 👨‍💻 Author

**Hafiz Muhammad Salman**

**Cloud DevOps Engineer | Linux Administrator**

GitHub:

[github.com/msalman199](https://github.com/msalman199?utm_source=chatgpt.com)

---

# ⭐ Repository

If you find this repository useful for learning Infrastructure as Code, feel free to ⭐ **Star** the repository and explore the individual labs.

[Infrastructure-as-Code-IaC Repository](https://github.com/msalman199/-Infrastructure-as-Code-IaC-?utm_source=chatgpt.com)

---

## 📜 Disclaimer

This repository is intended for **educational, training, and hands-on learning purposes**.

Always review infrastructure configurations, credentials, permissions, and security controls carefully before adapting lab configurations for production environments.

---

<p align="center">
  <b>🚀 Learn • Automate • Secure • Deploy • Repeat 🔥</b>
</p>
