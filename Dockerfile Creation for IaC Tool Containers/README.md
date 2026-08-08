<div align="center">

# 🐳 Dockerfile Creation for IaC Tool Containers

![Docker](https://img.shields.io/badge/Docker-CE-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-CLI-844FBA?style=for-the-badge&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-Core-EE0000?style=for-the-badge&logo=ansible&logoColor=white)
![Alpine](https://img.shields.io/badge/Base%20Image-Alpine%203.19-0D597F?style=for-the-badge&logo=alpinelinux&logoColor=white)
![Difficulty](https://img.shields.io/badge/Difficulty-Intermediate-orange?style=for-the-badge)

**Package Terraform and Ansible into lightweight, reusable Docker images — and push them to a local registry**

</div>

---

## 📑 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Environment Setup](#️-environment-setup)
- [🧩 Tasks](#-tasks)
  - [Task 1: 🐳 Install and Verify Docker](#task-1-🐳-install-and-verify-docker)
  - [Task 2: 📝 Write a Dockerfile for Terraform](#task-2-📝-write-a-dockerfile-for-terraform)
  - [Task 3: 🏗️ Build, Tag, and Run the Terraform Image](#task-3-🏗️-build-tag-and-run-the-terraform-image)
  - [Task 4: ➕ Extend the Dockerfile for Ansible and Python](#task-4-➕-extend-the-dockerfile-for-ansible-and-python)
  - [Task 5: 📄 Add Sample Terraform Config and Ansible Playbook](#task-5-📄-add-sample-terraform-config-and-ansible-playbook)
  - [Task 6: 🚀 Build, Run, and Execute Both Tools](#task-6-🚀-build-run-and-execute-both-tools)
  - [Task 7: 📤 Push Image to a Local Docker Registry](#task-7-📤-push-image-to-a-local-docker-registry)
- [🔑 Key Concepts](#-key-concepts)
- [✅ Verification Checklist](#-verification-checklist)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | Install and verify Docker on a Linux machine |
| 2 | Write a Dockerfile that packages Terraform CLI on a lightweight base image |
| 3 | Build, tag, and run Docker containers to validate IaC tool installation |
| 4 | Extend a Dockerfile to include Ansible, Python dependencies, and project files |
| 5 | Execute Terraform and Ansible commands inside a running container |
| 6 | Push a custom image to a local Docker registry for CI/CD reuse |

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| Linux command-line | Basic familiarity (`cd`, `mkdir`, `nano`/`vim`) |
| Terraform & Ansible | Basic understanding of concepts |
| Docker concepts | Images, containers, layers — helpful but not required |
| Access | Root or sudo access on the provided Linux machine |

## 🖥️ Environment Setup

> - Al Nafi provides a single Linux machine (Ubuntu-based) via Start Lab
> - All work is done in one terminal session — no external cloud accounts needed
> - Internet access is required to pull base images and packages

---

## 🧩 Tasks

### Task 1: 🐳 Install and Verify Docker

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
echo "deb [signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
```

**Verify installation:**

```bash
docker --version
sudo systemctl status docker --no-pager
```

**Add your user to the docker group to avoid using sudo for every command:**

```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Task 2: 📝 Write a Dockerfile for Terraform

**1️⃣ Create a project directory:**

```bash
mkdir -p ~/iac-container/terraform-only && cd ~/iac-container/terraform-only
```

**2️⃣ Create `Dockerfile` with the following starter template — complete the TODOs:**

```dockerfile
# Use a lightweight base image
FROM alpine:3.19

# TODO: Set environment variable for Terraform version (e.g., 1.7.5)
ENV TERRAFORM_VERSION=___

# TODO: Install required packages: curl, unzip
RUN apk add --no-cache ___

# TODO: Download and install Terraform binary from HashiCorp releases
# Hint: URL pattern -> https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN curl -O ___ && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

WORKDIR /workspace

ENTRYPOINT ["terraform"]
```

> 💡 Reference the Terraform releases page for a valid current version number.

### Task 3: 🏗️ Build, Tag, and Run the Terraform Image

```bash
docker build -t terraform-cli:1.0 .
docker images | grep terraform-cli
```

**Run a container to verify Terraform works:**

```bash
docker run --rm terraform-cli:1.0 --version
```

> 🛠️ **Troubleshooting:**
> - If build fails on `unzip`, confirm the package was added in the `apk add` line
> - If `terraform: not found`, check the binary path is `/usr/local/bin/terraform` and it has execute permission (`chmod +x` may be required after unzip)

### Task 4: ➕ Extend the Dockerfile for Ansible and Python

**1️⃣ Create a new directory for the extended image:**

```bash
mkdir -p ~/iac-container/full-iac && cd ~/iac-container/full-iac
```

**2️⃣ Create `Dockerfile`:**

```dockerfile
FROM alpine:3.19

ENV TERRAFORM_VERSION=1.7.5

# Install Terraform dependencies + Python + pip
RUN apk add --no-cache curl unzip python3 py3-pip bash

# Install Terraform
RUN curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# TODO: Install Ansible via pip (use --break-system-packages if required by base image)
RUN pip3 install ___

WORKDIR /workspace

# TODO: Add a default shell entrypoint so both tools are accessible interactively
ENTRYPOINT ["___"]
```

> 💡 Confirm Ansible installs cleanly: some Alpine/pip combinations require `--no-cache-dir` or `--break-system-packages` flags — check pip's error output if the build fails.

### Task 5: 📄 Add Sample Terraform Config and Ansible Playbook

**1️⃣ Create sample files in the same directory:**

`main.tf`:

```hcl
terraform {
  required_version = ">= 1.0"
}

resource "local_file" "sample" {
  filename = "${path.module}/sample_output.txt"  # 📄 written inside the container
  content  = "Hello from Terraform inside Docker"
}
```

`playbook.yml`:

```yaml
- hosts: localhost
  connection: local
  tasks:
    - name: Print a message
      debug:
        msg: "Hello from Ansible inside Docker"
```

**2️⃣ Update the Dockerfile to copy these files** — add this line before `WORKDIR`:

```dockerfile
# TODO: Copy main.tf and playbook.yml into the /workspace directory
COPY ___ /workspace/
```

### Task 6: 🚀 Build, Run, and Execute Both Tools

**1️⃣ Build the extended image:**

```bash
docker build -t iac-toolbox:1.0 .
```

**2️⃣ Run an interactive container:**

```bash
docker run --rm -it --entrypoint bash iac-toolbox:1.0
```

**3️⃣ Inside the container, execute:**

```bash
cd /workspace
terraform init
terraform plan
ansible-playbook playbook.yml
```

> ✅ **Expected:** Terraform plan shows a `local_file` resource creation; Ansible outputs the debug message

**4️⃣ Exit the container with `exit`**

> 🛠️ **Troubleshooting:**
> - If `terraform init` fails, ensure the local provider can be downloaded (requires internet access inside the container)
> - If `ansible-playbook: command not found`, re-check the pip install step in Task 4

### Task 7: 📤 Push Image to a Local Docker Registry

**1️⃣ Start a local registry container:**

```bash
docker run -d -p 5000:5000 --restart=always --name registry registry:2
```

**2️⃣ Tag and push your image:**

```bash
docker tag iac-toolbox:1.0 localhost:5000/iac-toolbox:1.0
docker push localhost:5000/iac-toolbox:1.0
```

**3️⃣ Verify the image is stored in the registry:**

```bash
curl http://localhost:5000/v2/_catalog
```

> ✅ **Expected output:** `{"repositories":["iac-toolbox"]}`

---

## 🔑 Key Concepts

| Concept | Description |
|---|---|
| **Base image** | The starting layer a Dockerfile builds from (e.g. `alpine:3.19` for a minimal footprint) |
| **Multi-stage tooling image** | A container packaging multiple CLI tools (Terraform + Ansible) for consistent, portable execution |
| **`ENTRYPOINT`** | Defines the default executable a container runs — can be overridden at `docker run` time |
| **`COPY`** | Embeds local files (configs, playbooks) into the image at build time |
| **Local Docker registry** | A self-hosted image store (`registry:2`) for pushing/pulling images without a public registry |
| **Image tagging** | Labeling a built image (`name:tag`) to version and target it for a specific registry |

## ✅ Verification Checklist

- [ ] `docker --version` returns a valid Docker version
- [ ] `docker run --rm terraform-cli:1.0 --version` prints Terraform version
- [ ] `iac-toolbox:1.0` image builds without errors
- [ ] `terraform plan` and `ansible-playbook playbook.yml` both run successfully inside the container
- [ ] Local registry catalog lists `iac-toolbox`

## 🏁 Conclusion

In this lab, you installed Docker on a Linux machine and built a custom container image packaging Terraform CLI using a lightweight Alpine base. You extended this image to include Ansible and Python dependencies, embedded sample IaC artifacts (a Terraform configuration and an Ansible playbook) using the `COPY` instruction, and validated both tools by executing them inside a running container. Finally, you deployed a local Docker registry and pushed your custom image to it, simulating a reusable artifact suitable for CI/CD pipelines.

**🎯 Key Accomplishments:**
- ✅ Installed and verified Docker on a Linux host
- ✅ Built a minimal Alpine-based Terraform CLI image
- ✅ Extended the image with Ansible, Python, and embedded IaC artifacts
- ✅ Executed Terraform and Ansible successfully inside a running container
- ✅ Deployed a local registry and pushed a custom image to it

**🌍 Real-World Applications:**
These skills — Dockerfile authoring, multi-tool image builds, and local registry management — are foundational for DevOps and Platform Engineer roles working with containerized Infrastructure as Code workflows.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
