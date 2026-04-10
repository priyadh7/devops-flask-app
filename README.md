# End-to-End DevOps Implementation
### Containerized Flask Web Application using GitHub Actions, Docker, Kubernetes, and Terraform

---

## Project Overview

This project demonstrates a complete DevOps pipeline for a minimal Python Flask web application.
The focus is entirely on **DevOps tooling and automation** — not application complexity.

The application accepts text input from a user and displays a processed output.
Around this simple app, a full production-grade DevOps pipeline is built.

---

## Tools & Technologies

| Category              | Tool / Service                        |
|-----------------------|---------------------------------------|
| Application           | Python 3.10, Flask, Gunicorn          |
| Version Control       | Git, GitHub                           |
| Containerization      | Docker, Docker Compose                |
| Container Registry    | Azure Container Registry (ACR)        |
| Infrastructure as Code| Terraform (Azure Provider)            |
| Orchestration         | Kubernetes (AKS)                      |
| Configuration Mgmt    | Ansible                               |
| CI/CD                 | GitHub Actions                        |
| Cloud Provider        | Microsoft Azure                       |

---

## Architecture

```
Developer (Local)
      │
      │  git push → main
      ▼
┌─────────────────────────────────────────────────────┐
│              GitHub Actions (CI/CD)                 │
│  1. Checkout Code                                   │
│  2. Build Docker Image                              │
│  3. Push to ACR                                     │
│  4. Deploy to AKS via kubectl                       │
└──────────────┬──────────────────────────────────────┘
               │
       ┌───────▼────────┐        ┌──────────────────┐
       │  Azure ACR     │        │  Terraform        │
       │  (Image Store) │        │  Provisions:      │
       └───────┬────────┘        │  - Resource Group │
               │                 │  - ACR            │
       ┌───────▼────────┐        │  - AKS Cluster    │
       │  Azure AKS     │◄───────┘                   │
       │  - 2 Pod Replicas                            │
       │  - LoadBalancer Service (Public IP)          │
       └──────────────────────────────────────────────┘
```

---

## Repository Structure

```
DEVOPS PROJECT/
├── app/
│   ├── app.py                  # Flask application
│   ├── requirements.txt        # Python dependencies
│   ├── Dockerfile              # Container build instructions
│   └── templates/
│       └── index.html          # Single-page UI
├── k8s/
│   ├── deployment.yaml         # Kubernetes Deployment (2 replicas)
│   └── service.yaml            # Kubernetes LoadBalancer Service
├── terraform/
│   ├── main.tf                 # Root module — calls sub-modules
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Output values
│   └── modules/
│       ├── resource_group/     # Azure Resource Group
│       ├── acr/                # Azure Container Registry
│       └── aks/                # Azure Kubernetes Service
├── ansible/
│   ├── playbook.yml            # Install Docker + configure env
│   └── inventory.ini           # Target host definitions
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions CI/CD pipeline
├── docker-compose.yml          # Local development testing
├── .gitignore
└── README.md
```

---

## Branching Strategy

```
main   ──────●──────────────●──────────────●──────▶  (production)
              \            /
dev    ─────────●────●────●────────────────────────▶  (development)
                     \   /
feature              ─●─                             (feature branch)
```

| Branch    | Purpose                                      |
|-----------|----------------------------------------------|
| `main`    | Production-ready code — triggers CI/CD       |
| `dev`     | Integration branch for ongoing development   |
| `feature/*` | Short-lived branches for individual tasks  |

### Sample Commit Messages
```
feat: add Flask input form and echo logic
docker: add Dockerfile with gunicorn entrypoint
terraform: provision AKS and ACR modules
k8s: add deployment and loadbalancer service manifests
ansible: add Docker installation playbook
ci: add GitHub Actions build-push-deploy workflow
docs: update README with architecture diagram
```

---

## Phase-by-Phase Setup Guide

---

### Phase 1 — Git & GitHub

**Objective:** Initialize version control and push project to GitHub.

**Steps:**
```bash
git init
git remote add origin https://github.com/<your-username>/devops-flask-app.git
git checkout -b dev
git add .
git commit -m "feat: initial project structure"
git push -u origin dev

# Merge to main when ready
git checkout main
git merge dev
git push origin main
```

**Expected Output:** Repository visible on GitHub with all folders and files.

---

### Phase 2 — Docker

**Objective:** Containerize the Flask app and test locally.

**Build and run with Docker:**
```bash
cd app
docker build -t flask-app:latest .
docker run -p 5000:5000 flask-app:latest
# Visit: http://localhost:5000
```

**Run with Docker Compose (from project root):**
```bash
docker-compose up --build
# Visit: http://localhost:5000
```

**Expected Output:** Flask app accessible in browser at `http://localhost:5000`.

---

### Phase 3 — Terraform (Azure Infrastructure)

**Objective:** Provision Resource Group, ACR, and AKS on Azure using IaC.

**Prerequisites:**
- Azure CLI installed and logged in: `az login`
- Terraform installed: `terraform -v`

**Steps:**
```bash
cd terraform
terraform init        # Download Azure provider plugins
terraform plan        # Preview resources to be created
terraform apply       # Provision infrastructure (confirm with 'yes')
```

**Expected Output:**
- Resource Group `devops-project-rg` created in Azure Portal
- ACR `devopsprojectacr.azurecr.io` available
- AKS cluster `devops-aks-cluster` running with 2 nodes

---

### Phase 4 — Kubernetes

**Objective:** Deploy the containerized app to AKS.

**Steps:**
```bash
# Connect kubectl to AKS
az aks get-credentials --resource-group devops-project-rg --name devops-aks-cluster

# Apply manifests
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Check status
kubectl get pods
kubectl get service flask-app-service
```

**Expected Output:**
- 2 pods in `Running` state
- Service shows an external `EXTERNAL-IP` (Azure public IP)
- App accessible at `http://<EXTERNAL-IP>`

---

### Phase 5 — Ansible

**Objective:** Automate Docker installation on a remote server.

**Steps:**
```bash
# Edit inventory.ini with your server IP
cd ansible
ansible-playbook -i inventory.ini playbook.yml
```

**Expected Output:** Docker installed and running on the target server. Final task prints Docker version.

---

### Phase 6 — CI/CD (GitHub Actions)

**Objective:** Automate the full build → push → deploy pipeline on every push to `main`.

**Setup GitHub Secrets** (Settings → Secrets → Actions):

| Secret Name         | Value                                              |
|---------------------|----------------------------------------------------|
| `AZURE_CREDENTIALS` | Output of `az ad sp create-for-rbac --sdk-auth`   |

**Trigger the pipeline:**
```bash
git add .
git commit -m "ci: trigger deployment"
git push origin main
```

**Expected Output:**
- GitHub Actions tab shows a green pipeline run
- All 8 steps complete successfully
- New image deployed to AKS automatically

---

## Local Quick Start

```bash
# Clone the repo
git clone https://github.com/<your-username>/devops-flask-app.git
cd devops-flask-app

# Run locally with Docker Compose
docker-compose up --build

# Open browser
http://localhost:5000
```

---

## GitHub Actions Required Secrets

| Secret              | Description                                  |
|---------------------|----------------------------------------------|
| `AZURE_CREDENTIALS` | Azure Service Principal JSON (for az login)  |

Generate with:
```bash
az ad sp create-for-rbac \
  --name "devops-github-actions" \
  --role contributor \
  --scopes /subscriptions/<subscription-id> \
  --sdk-auth
```

---

*Project developed for university evaluation — End-to-End DevOps Implementation*
