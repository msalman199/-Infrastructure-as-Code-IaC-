<div align="center">

# 📚 Document Infrastructure with DSL and Diagrams

![Python](https://img.shields.io/badge/Python-3-3776AB?style=for-the-badge&logo=python&logoColor=white)
![YAML](https://img.shields.io/badge/Manifest-YAML-CB171E?style=for-the-badge&logo=yaml&logoColor=white)
![Graphviz](https://img.shields.io/badge/Graphviz-Diagrams--as--Code-2C3E50?style=for-the-badge&logo=graphviz&logoColor=white)
![IaC](https://img.shields.io/badge/Focus-Documentation--First%20IaC-0052CC?style=for-the-badge)
![Difficulty](https://img.shields.io/badge/Difficulty-Beginner-brightgreen?style=for-the-badge)

**Build a documentation-first Infrastructure as Code repository — manifest, docs, deployment plan, and an auto-generated architecture diagram**

</div>

---

## 📑 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Environment Setup](#️-environment-setup)
- [🧩 Tasks](#-tasks)
  - [Task 1: 📁 Create the Repository Folder Structure](#task-1-📁-create-the-repository-folder-structure)
  - [Task 2: 📝 Write the README.md](#task-2-📝-write-the-readmemd)
  - [Task 3: 📄 Create the YAML Infrastructure Manifest](#task-3-📄-create-the-yaml-infrastructure-manifest)
  - [Task 4: 🗂️ Document Infrastructure Components](#task-4-🗂️-document-infrastructure-components)
  - [Task 5: 🚦 Create the Deployment Plan](#task-5-🚦-create-the-deployment-plan)
  - [Task 6: 🖼️ Generate an Architecture Diagram (Diagrams-as-Code)](#task-6-🖼️-generate-an-architecture-diagram-diagrams-as-code)
- [🔑 Key Concepts](#-key-concepts)
- [✅ Verification](#-verification)
- [🛠️ Troubleshooting](#️-troubleshooting)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | Create a standard DevOps repository folder structure |
| 2 | Write clear documentation (`README.md`) for infrastructure repositories |
| 3 | Build a YAML-based infrastructure manifest describing a three-tier application |
| 4 | Document compute, networking, and storage components in a structured format |
| 5 | Create a basic deployment plan with rollback procedures |
| 6 | Generate a simple architecture diagram using a text-based diagramming tool |

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| Linux terminal familiarity | Navigating folders, creating files |
| YAML/diagramming experience | None required |
| Machine | A single Linux machine (provided via Al Nafi Start Lab) |

## 🖥️ Environment Setup

**1️⃣ Start your Linux lab machine from Al Nafi.**

**2️⃣ Open a terminal.**

**3️⃣ Install required tools:**

```bash
# Update package list
sudo apt update

# Install Python and pip (used for diagrams-as-code tool)
sudo apt install -y python3 python3-pip

# Install Graphviz (required by the Python "diagrams" library)
sudo apt install -y graphviz

# Install the diagrams Python library
pip3 install diagrams --user

# Verify installations
python3 --version
dot -V
```

---

## 🧩 Tasks

### Task 1: 📁 Create the Repository Folder Structure

**1️⃣ Create a root project folder and move into it:**

```bash
mkdir ~/devops-repo
cd ~/devops-repo
```

**2️⃣ Create the required subdirectories:**

```bash
# docs -> holds documentation files
# modules -> holds reusable infrastructure definitions
# environments -> holds environment-specific configs (dev/test/prod)
# scripts -> holds automation/helper scripts
mkdir docs modules environments scripts
```

**3️⃣ Confirm the structure:**

```bash
ls -R
```

> ✅ **Expected output:** Four empty folders — `docs`, `modules`, `environments`, `scripts`.

### Task 2: 📝 Write the README.md

**1️⃣ Create the file:**

```bash
touch README.md
nano README.md
```

**2️⃣ Add the following content (edit as needed):**

```markdown
# DevOps Infrastructure Repository

This repository documents the infrastructure design for a sample three-tier application.

## Folder Structure

- **docs/**: Contains architecture documentation, deployment plans, and diagrams.
- **modules/**: Contains reusable infrastructure component definitions (compute, network, storage).
- **environments/**: Contains environment-specific manifests (dev, test, prod).
- **scripts/**: Contains helper scripts for automation tasks.

## Purpose
This repo serves as a documentation-first approach to Infrastructure as Code (IaC),
describing intended infrastructure state before implementation.
```

**3️⃣ Save and exit** *(`Ctrl+O`, `Enter`, `Ctrl+X` in nano)*.

### Task 3: 📄 Create the YAML Infrastructure Manifest

**1️⃣ Create the manifest file inside `environments`:**

```bash
touch environments/dev.yaml
nano environments/dev.yaml
```

**2️⃣ Add the following YAML describing a three-tier app (web, app, database):**

```yaml
# dev.yaml - Desired state for the Dev environment
application:
  name: sample-three-tier-app  # 🏷️ app identifier
  environment: dev

tiers:
  web:
    type: compute
    instance_count: 2           # 🖥️ scaling
    cpu: "1 vCPU"
    memory: "2GB"
    port: 80

  app:
    type: compute
    instance_count: 2
    cpu: "2 vCPU"
    memory: "4GB"
    port: 8080

  database:
    type: storage
    engine: postgresql           # 🗄️ DB engine
    version: "14"
    storage_size: "20GB"
    port: 5432

networking:
  vpc_name: dev-vpc
  subnets:
    - name: web-subnet           # 🌐 web tier subnet
      cidr: 10.0.1.0/24
    - name: app-subnet
      cidr: 10.0.2.0/24
    - name: db-subnet
      cidr: 10.0.3.0/24
```

**3️⃣ Save and validate the YAML syntax:**

```bash
# Install a simple YAML validator
pip3 install pyyaml --user

# Validate the file
python3 -c "import yaml; yaml.safe_load(open('environments/dev.yaml'))" && echo "YAML is valid"
```

### Task 4: 🗂️ Document Infrastructure Components

**1️⃣ Create a components document:**

```bash
touch docs/infrastructure-components.md
nano docs/infrastructure-components.md
```

**2️⃣ Add structured documentation:**

```markdown
# Infrastructure Components

## Compute
| Tier | Instances | CPU | Memory |
|------|-----------|-----|--------|
| Web  | 2         | 1 vCPU | 2GB |
| App  | 2         | 2 vCPU | 4GB |

## Networking
| Subnet Name | CIDR Block   | Purpose        |
|-------------|--------------|----------------|
| web-subnet  | 10.0.1.0/24  | Web tier traffic |
| app-subnet  | 10.0.2.0/24  | App tier traffic |
| db-subnet   | 10.0.3.0/24  | Database traffic |

## Storage
| Component | Engine     | Size  |
|-----------|------------|-------|
| Database  | PostgreSQL | 20GB  |
```

### Task 5: 🚦 Create the Deployment Plan

**1️⃣ Create the deployment plan file:**

```bash
touch docs/deployment-plan.md
nano docs/deployment-plan.md
```

**2️⃣ Add the following template and fill in details:**

```markdown
# Deployment Plan - Sample Three-Tier App

## Pre-Deployment Checks
- [ ] Verify YAML manifest syntax is valid
- [ ] Confirm target environment (dev) exists
- [ ] Check available compute and storage capacity
- [ ] Notify team of scheduled deployment window

## Execution Steps
1. Review infrastructure manifest (environments/dev.yaml)
2. Provision networking (VPC and subnets)
3. Provision database (storage tier)
4. Provision app tier compute instances
5. Provision web tier compute instances
6. Run smoke tests to confirm connectivity between tiers

## Rollback Procedures
1. Identify the failed component (web, app, or database)
2. Stop new deployments immediately
3. Restore previous known-good manifest version
4. Re-run provisioning using the previous manifest
5. Confirm application health after rollback
```

### Task 6: 🖼️ Generate an Architecture Diagram (Diagrams-as-Code)

**1️⃣ Create a Python script inside `scripts`:**

```bash
nano scripts/generate_diagram.py
```

**2️⃣ Add and complete the following starter code:**

```python
# generate_diagram.py
# This script generates a simple architecture diagram
# for our sample three-tier application using the "diagrams" library.

from diagrams import Diagram, Cluster
from diagrams.onprem.compute import Server
from diagrams.onprem.database import PostgreSQL
from diagrams.onprem.network import Nginx

# TODO 1: Set the diagram filename and title
# Hint: Diagram("Three-Tier App Architecture", filename="docs/architecture", show=False)
with Diagram("Three-Tier App Architecture", filename="docs/architecture", show=False):

    # TODO 2: Create a cluster for the Web tier with 1 Nginx node
    with Cluster("Web Tier"):
        web = Nginx("web-server")

    # TODO 3: Create a cluster for the App tier with 1 Server node
    with Cluster("App Tier"):
        app = Server("app-server")

    # TODO 4: Create a cluster for the Database tier with 1 PostgreSQL node
    with Cluster("Database Tier"):
        db = PostgreSQL("database")

    # TODO 5: Connect the tiers: web -> app -> db
    web >> app >> db
```

**3️⃣ Run the script:**

```bash
cd ~/devops-repo
python3 scripts/generate_diagram.py
```

**4️⃣ Confirm the diagram was created:**

```bash
ls docs/
# You should see architecture.png
```

---

## 🔑 Key Concepts

| Concept | Description |
|---|---|
| **Documentation-first IaC** | Describing intended infrastructure state in docs/manifests before implementation |
| **Infrastructure manifest** | A structured (YAML) file capturing the desired state of compute, networking, and storage |
| **Three-tier architecture** | An app split into web, application, and database tiers, each independently scalable |
| **Deployment plan** | A documented sequence of pre-checks, execution steps, and rollback procedures |
| **Diagrams-as-code** | Generating architecture diagrams programmatically (e.g. Python `diagrams` + Graphviz) instead of hand-drawing them |
| **Rollback procedure** | A predefined, ordered set of steps to restore a known-good state after a failed deployment |

## ✅ Verification

Run these checks to confirm your lab is complete:

```bash
# 1. Check folder structure exists
ls ~/devops-repo

# 2. Confirm README.md has content
cat ~/devops-repo/README.md | head -5

# 3. Validate YAML manifest
python3 -c "import yaml; yaml.safe_load(open('environments/dev.yaml')); print('Valid YAML')"

# 4. Confirm documentation files exist
ls ~/devops-repo/docs

# 5. Confirm diagram image was generated
file ~/devops-repo/docs/architecture.png
```

**Expected results:**
- Folder structure shows `docs`, `modules`, `environments`, `scripts`
- `README.md` displays repository purpose text
- YAML validation prints `"Valid YAML"`
- `docs/` contains `infrastructure-components.md`, `deployment-plan.md`, `architecture.png`

## 🛠️ Troubleshooting

<details>
<summary><strong>🔧 Click to expand common issues and fixes</strong></summary>

<br>

| Issue | Fix |
|---|---|
| YAML validation fails | Check indentation — YAML requires consistent spacing (no tabs) |
| `dot: command not found` | Re-run `sudo apt install -y graphviz` |
| Diagram script errors on import | Ensure `pip3 install diagrams --user` completed successfully; try `pip3 install --upgrade diagrams` |
| Permission denied creating folders | Ensure you are working inside your home directory (`~/devops-repo`), not a restricted system path |

</details>

## 🏁 Conclusion

In this lab, you built a foundational IaC documentation repository on a single Linux machine. You created a standard DevOps folder structure, wrote a README explaining its purpose, and authored a YAML manifest describing a three-tier application's desired state. You also documented infrastructure components (compute, networking, storage) in structured tables, created a deployment plan with rollback steps, and used a diagrams-as-code Python tool to generate a visual architecture diagram.

**🎯 Key Accomplishments:**
- ✅ Established a standard DevOps repository folder structure
- ✅ Wrote a purpose-driven README for the infrastructure repo
- ✅ Authored a validated YAML manifest describing a three-tier application
- ✅ Documented compute, networking, and storage components in structured tables
- ✅ Created a deployment plan with pre-checks, execution steps, and rollback procedures
- ✅ Generated an architecture diagram programmatically with diagrams-as-code

**🌍 Real-World Applications:**
These skills form the basis of documentation-first infrastructure practices used by DevOps Engineers and Infrastructure Architects in real-world IaC workflows.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
