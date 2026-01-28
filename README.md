# ScoutStig
## DISA STIG tool

ScoutStig is an **air-gapped STIG compliance platform** built around MariaDB. It is designed for environments where network access is restricted or nonexistent, and where assessors need a repeatable, auditable way to track **manual STIG findings** without relying on web tools or vendor platforms.

ScoutStig ingests DISA XCCDF STIGs, stores rules and metadata in MariaDB, tracks findings per scan, and exports results as **CKLB files** compatible with DISA STIG Viewer.

This project is intentionally boring in the right ways: predictable, inspectable, scriptable, and defensible during audits.

---

## What ScoutStig Is (and Is Not)

**ScoutStig is:**
- A local STIG data store
- A workflow tool for manual STIG assessments
- A CKLB generator compatible with STIG Viewer
- Designed for air-gapped or classified environments

**ScoutStig is not:**
- A vulnerability scanner
- A replacement for SCAP scanners
- A web application
- A magic compliance button

ScoutStig assumes a human assessor is doing the thinking. The tool exists to record, structure, and export that thinking.

---

## High-Level Architecture

```
XCCDF STIG (XML)
        │
        ▼
  stigctl.py import
        │
        ▼
   MariaDB (ScoutStig schema)
        │
        ├─ WorkFindings.sql  ← assessor queries & notes
        │
        └─ stigctl.py export
                │
                ▼
           CKLB file
                │
                ▼
         DISA STIG Viewer
```

MariaDB is the system of record. Everything else reads from or writes to it.

---

## Repository Layout

```
ScoutStig/
├─ setup.sh
├─ stigctl.py
├─ stigctl.conf
├─ schema.sql
├─ WorkFindings.sql
├─ README.md
├─ stig/
│   └─ *.xml
└─ output/
    └─ *.cklb
```

---

## Requirements

### System
- Linux system
- Air-gapped friendly

### Software
- MariaDB 10.x
- Python 3.9+
- MariaDB client tools

### Permissions
- MariaDB database/user creation
- Local filesystem write access

---

## Installation & Setup

### Install MariaDB
```
systemctl enable --now mariadb
```

### Configure ScoutStig
Edit `stigctl.conf`:
```
DB_HOST=localhost
DB_PORT=3306
DB_NAME=scoutstig
DB_USER=scoutstig
DB_PASS=changeme
DB_SOCKET=/var/lib/mysql/mysql.sock
```

### Run setup.sh
```
chmod +x setup.sh
./setup.sh
```

---

## Importing a STIG
```
python3 stigctl.py import stig/your-stig.xml
```

---

## Starting a Scan
```
python3 stigctl.py scan init --system "DB-Server-01" --stig "MariaDB 10.x" --assessor "J. Doe"
```

---

## Performing the Assessment

Use `WorkFindings.sql` as the assessor interface:
```
mariadb scoutstig < WorkFindings.sql
```

Statuses:
- Open
- NotAFinding
- NotApplicable

---

## Exporting CKLB
```
python3 stigctl.py export --scan-id 3 --output output/DB-Server-01.cklb
```

---

## Limitations
- Manual assessment only
- No GUI
- No automation

---

## Philosophy

ScoutStig keeps assessor judgment explicit, local, and auditable.
