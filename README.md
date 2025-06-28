# 🧹 EC2 Audit & Cleanup Script (Bash + AWS CLI)

This project provides a Bash-based auditing tool to identify AWS EC2 instances that have been running beyond a specified number of days and optionally stop them to reduce costs.

## 📌 Features

- Lists all **running EC2 instances**
- Calculates **uptime in days** based on launch time
- Flags instances running for more than **7 days**
- Interactively asks whether to **stop** flagged instances
- Uses **AWS CLI** and **jq** for fast and lightweight processing

---

## ⚙️ Prerequisites

- AWS CLI configured (`aws configure`)
- `jq` installed for JSON parsing:
  ```bash
  sudo apt install jq -y

#result:
-[result](./Screenshot.png)
