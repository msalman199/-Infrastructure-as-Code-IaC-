<div align="center">

# 🤖 Install Ansible and Write Your First Playbook

![Ansible](https://img.shields.io/badge/Ansible-Core-EE0000?style=for-the-badge&logo=ansible&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Ubuntu%2FRHEL-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![YAML](https://img.shields.io/badge/Config-YAML%20Playbooks-CB171E?style=for-the-badge&logo=yaml&logoColor=white)
![Difficulty](https://img.shields.io/badge/Difficulty-Beginner-brightgreen?style=for-the-badge)
![Cert](https://img.shields.io/badge/Aligned%20With-RHCE-blue?style=for-the-badge)

**Install Ansible, write your first playbook, and prove idempotency with handlers**

</div>

---

## 📑 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Environment Setup](#️-environment-setup)
- [🧩 Tasks](#-tasks)
  - [Task 1: 📥 Install Ansible Using pip](#task-1-📥-install-ansible-using-pip)
  - [Task 2: 📋 Create a Local Inventory File](#task-2-📋-create-a-local-inventory-file)
  - [Task 3: 🔌 Test Connectivity with an Ad-Hoc Command](#task-3-🔌-test-connectivity-with-an-ad-hoc-command)
  - [Task 4: 📝 Write Your First Playbook](#task-4-📝-write-your-first-playbook)
  - [Task 5: ➕ Add a Task Using lineinfile](#task-5-➕-add-a-task-using-lineinfile)
  - [Task 6: 🔁 Run the Playbook and Verify Idempotency](#task-6-🔁-run-the-playbook-and-verify-idempotency)
  - [Task 7: 🔔 Add a Handler for Notifications](#task-7-🔔-add-a-handler-for-notifications)
- [🔑 Key Concepts](#-key-concepts)
- [✅ Verification Checklist](#-verification-checklist)
- [🛠️ Troubleshooting Tips](#️-troubleshooting-tips)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | Install Ansible using pip on a Linux machine |
| 2 | Configure a local inventory file |
| 3 | Run ad-hoc Ansible commands to test connectivity |
| 4 | Write a basic YAML playbook using the `file`, `copy`, and `lineinfile` modules |
| 5 | Verify playbook idempotency |
| 6 | Add a handler to trigger notifications on file changes |

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| Linux terminal familiarity | `cd`, `mkdir`, `nano`/`vim` |
| Ansible experience | None required |
| Machine | A single Linux machine (Ubuntu/Debian or RHEL/CentOS based) |

## 🖥️ Environment Setup

> - Use the single Linux machine provided via Al Nafi's Start Lab feature
> - Ensure you have terminal access with a non-root user that has sudo privileges
> - Internet access is required to install packages via pip

---

## 🧩 Tasks

### Task 1: 📥 Install Ansible Using pip

**1️⃣ Update your system packages:**

```bash
sudo apt update -y        # For Ubuntu/Debian
# OR
sudo yum update -y        # For RHEL/CentOS
```

**2️⃣ Install Python3 and pip if not already installed:**

```bash
sudo apt install python3 python3-pip -y
```

**3️⃣ Install ansible-core using pip:**

```bash
pip3 install --user ansible-core
```

**4️⃣ Add pip's local bin directory to your PATH (if needed):**

```bash
export PATH=$PATH:~/.local/bin
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
source ~/.bashrc
```

**5️⃣ Verify the installation:**

```bash
ansible --version
```

> ✅ **Expected output:** You should see the Ansible version number along with Python version details.

### Task 2: 📋 Create a Local Inventory File

**1️⃣ Create a project directory:**

```bash
mkdir ~/ansible-lab && cd ~/ansible-lab
```

**2️⃣ Create an inventory file named `inventory.ini`:**

```bash
nano inventory.ini
```

**3️⃣ Add the following content** (defines localhost using a local connection, so no SSH is needed):

```ini
[local]
localhost ansible_connection=local
```

**4️⃣ Save and exit** *(`Ctrl+O`, `Enter`, `Ctrl+X` in nano)*.

### Task 3: 🔌 Test Connectivity with an Ad-Hoc Command

Run the built-in `ping` module against your inventory:

```bash
ansible -i inventory.ini local -m ping
```

**Expected output:**

```json
localhost | SUCCESS => {
    "ansible_facts": { "discovered_interpreter_python": "/usr/bin/python3" },
    "changed": false,
    "ping": "pong"
}
```

> 💡 **Note:** Ansible's `ping` module just checks if it can connect and run Python — it does not send ICMP packets.

### Task 4: 📝 Write Your First Playbook

**1️⃣ Create a file named `first_playbook.yml`:**

```bash
nano first_playbook.yml
```

**2️⃣ Add the following YAML content.** Read every comment carefully:

```yaml
---
# This playbook creates a directory and a configuration file
- name: My First Ansible Playbook          # Human-readable name for the play
  hosts: local                             # Target group from inventory.ini
  become: yes                              # Run tasks with sudo privileges

  tasks:
    # TASK 1: Create a directory using the 'file' module
    - name: Create app directory
      file:
        path: /tmp/myapp        # 📁 Directory to create
        state: directory        # 'directory' tells Ansible to create a folder
        mode: '0755'            # 🔐 Permissions for the directory

    # TASK 2: Create a config file using the 'copy' module
    - name: Create config file with initial content
      copy:
        content: "# App Configuration File\n"   # ✍️ Text written into the file
        dest: /tmp/myapp/app.conf                # 📄 Destination path
        mode: '0644'
```

**3️⃣ Save and exit.**

### Task 5: ➕ Add a Task Using lineinfile

Edit `first_playbook.yml` and add this task after the `copy` task (keep the same indentation level as other tasks under `tasks:`):

```yaml
    # TASK 3: Insert a line into the config file if it doesn't already exist
    - name: Add setting to config file
      lineinfile:
        path: /tmp/myapp/app.conf       # 📄 File to edit
        line: "environment=production"  # ➕ Line to insert
        state: present                  # Ensure the line exists
      notify: Config Changed            # 🔔 Triggers the handler (added in Task 7)
```

### Task 6: 🔁 Run the Playbook and Verify Idempotency

**1️⃣ Run the playbook for the first time:**

```bash
ansible-playbook -i inventory.ini first_playbook.yml
```

> ✅ **Expected output:** Tasks show `changed=` counts greater than 0 (e.g., `changed=3`).

**2️⃣ Run the playbook again:**

```bash
ansible-playbook -i inventory.ini first_playbook.yml
```

> ✅ **Expected output:** All tasks should now show `changed=0` (except handlers, which won't run). This proves **idempotency** — running the playbook multiple times produces the same end state without unnecessary changes.

**3️⃣ Confirm the file contents:**

```bash
cat /tmp/myapp/app.conf
```

### Task 7: 🔔 Add a Handler for Notifications

Handlers run only when notified by a task that reports a change.

**1️⃣ Add this section at the bottom of `first_playbook.yml`, aligned with `tasks:`** (same indentation level as `hosts:`):

```yaml
  handlers:
    # This handler runs only if a task above uses "notify: Config Changed"
    - name: Config Changed
      debug:
        msg: "Configuration file was updated! Please review changes."
```

**Your complete playbook structure should now look like:**

```yaml
---
- name: My First Ansible Playbook
  hosts: local
  become: yes

  tasks:
    - name: Create app directory
      file:
        path: /tmp/myapp
        state: directory
        mode: '0755'

    - name: Create config file with initial content
      copy:
        content: "# App Configuration File\n"
        dest: /tmp/myapp/app.conf
        mode: '0644'

    - name: Add setting to config file
      lineinfile:
        path: /tmp/myapp/app.conf
        line: "environment=production"
        state: present
      notify: Config Changed

  handlers:
    - name: Config Changed
      debug:
        msg: "Configuration file was updated! Please review changes."
```

**2️⃣ Run it once more to see the handler fire:**

```bash
ansible-playbook -i inventory.ini first_playbook.yml
```

**3️⃣ Then delete the config file and re-run to trigger a real change and see the handler execute:**

```bash
rm /tmp/myapp/app.conf
ansible-playbook -i inventory.ini first_playbook.yml
```

---

## 🔑 Key Concepts

| Concept | Description |
|---|---|
| **Inventory** | A file (e.g. `inventory.ini`) that defines the hosts and groups Ansible manages |
| **Ad-hoc command** | A one-off Ansible module run directly from the CLI, without a playbook |
| **Playbook** | A YAML file describing a set of plays and tasks to run against target hosts |
| **Module** | A unit of Ansible functionality (`file`, `copy`, `lineinfile`, etc.) that a task invokes |
| **Idempotency** | Running the same playbook repeatedly produces the same end state, with no changes reported once state matches |
| **Handler** | A task that only runs when notified by another task reporting a change (`notify:`) |
| **`become`** | Directs Ansible to run tasks with elevated (sudo) privileges |

## ✅ Verification Checklist

- [ ] `ansible --version` returns a valid version number
- [ ] `inventory.ini` correctly lists `localhost` under `[local]`
- [ ] `ansible -i inventory.ini local -m ping` returns `"pong"`
- [ ] `/tmp/myapp/app.conf` exists and contains `environment=production`
- [ ] Second playbook run shows `changed=0` for file/copy/lineinfile tasks
- [ ] Handler message appears in output when config file changes

## 🛠️ Troubleshooting Tips

<details>
<summary><strong>🔧 Click to expand common issues and fixes</strong></summary>

<br>

| Issue | Fix |
|---|---|
| `ansible: command not found` | Ensure `~/.local/bin` is in your PATH (Task 1, step 4) |
| Permission denied errors | Confirm `become: yes` is set and your user has sudo rights |
| YAML errors | Check indentation — YAML is space-sensitive; use spaces, not tabs |
| Handler not firing | Ensure `notify: name` exactly matches the handler's `name:` value |

</details>

## 🏁 Conclusion

In this lab, you installed Ansible using pip, configured a local inventory, and verified connectivity with an ad-hoc `ping` command. You then wrote your first Ansible playbook using the `file`, `copy`, and `lineinfile` modules to automate directory and configuration file creation. You confirmed idempotency by running the playbook twice and observing no unnecessary changes on the second run. Finally, you implemented a handler to send a notification whenever configuration files were modified.

**🎯 Key Accomplishments:**
- ✅ Installed Ansible via pip and verified the installation
- ✅ Built a local inventory and tested connectivity with an ad-hoc command
- ✅ Wrote a playbook using `file`, `copy`, and `lineinfile` modules
- ✅ Verified idempotency across repeated playbook runs
- ✅ Implemented a handler that fires only on real configuration changes

**🌍 Real-World Applications:**
These are foundational Infrastructure as Code skills used daily by DevOps Engineers and Systems Administrators, and they align directly with RHCE certification objectives.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
