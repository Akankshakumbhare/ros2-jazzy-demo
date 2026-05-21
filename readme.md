ROS2 Jazzy CI/CD Demo
Project Overview

This project demonstrates a complete enterprise-grade CI/CD pipeline implementation for a ROS2 Jazzy application using:

Azure DevOps
Docker
Azure Kubernetes Service (AKS)
Azure Container Registry (ACR)
Terraform
Helm
NGINX Ingress Controller
cert-manager
Trivy Security Scanner
Prometheus
Grafana

The solution automatically provisions infrastructure, builds, scans, validates, containerizes, deploys, and monitors a ROS2 application whenever developers push code changes to GitHub.

High-Level Architecture
Developer Push
      ↓
GitHub Repository
      ↓
Azure DevOps Pipeline
      ↓
Terraform Infrastructure Provisioning
      ↓
Docker Build & Security Scan
      ↓
Azure Container Registry (ACR)
      ↓
Runtime Validation
      ↓
Azure Kubernetes Service (AKS)
      ↓
NGINX Ingress + TLS
      ↓
ROS2 Application Pod
      ↓
Prometheus + Grafana Monitoring
Architecture Components
Component	Purpose
GitHub	Source code management
Azure DevOps	CI/CD automation
Terraform	Infrastructure as Code
Docker	Containerization
Azure Container Registry	Container image storage
Azure Kubernetes Service	Kubernetes orchestration
Helm	Kubernetes package management
NGINX Ingress Controller	External traffic routing
cert-manager	Automatic TLS certificate management
Trivy	Container vulnerability scanning
Prometheus	Metrics collection
Grafana	Monitoring dashboards
Infrastructure Provisioning with Terraform

Terraform provisions:

Azure Resource Group
Azure Kubernetes Service (AKS)
Azure Container Registry (ACR)
Log Analytics Workspace
NGINX Ingress Controller
cert-manager
Kubernetes Namespace
ACR Pull Role Assignments
Terraform Files
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
└── terraform.tfvars
Initialize Terraform
terraform init
Validate Terraform
terraform validate
Apply Infrastructure
terraform apply -auto-approve
CI/CD Pipeline

The Azure DevOps pipeline automatically performs:

Stage 1 — Build and Security Scan
Pull latest source code from GitHub
Build Docker image using ACR Tasks
Push versioned image to Azure Container Registry
Install Trivy security scanner
Scan Docker image for vulnerabilities
Publish Trivy scan reports
Stage 2 — Runtime Validation
Pull Docker image from ACR
Run ROS2 container
Validate ROS2 publisher logs
Publish runtime logs as pipeline artifacts
Stage 3 — Deploy to AKS
Verify NGINX ingress controller
Retrieve external ingress IP
Create Kubernetes namespace
Deploy application manifests
Deploy ingress and TLS configuration
Validate pods, services, and ingress resources
Stage 4 — Automatic Rollback
Automatically rollback deployment if deployment fails

Pipeline file:

azure-pipelines.yml
Docker Configuration
Dockerfile
FROM prodacr001.azurecr.io/ros:jazzy-ros-base

LABEL maintainer="Akanksha"
LABEL description="ROS2 Jazzy CI/CD Demo"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-jazzy-examples-rclcpp-minimal-publisher \
    ros-jazzy-examples-rclcpp-minimal-subscriber \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash rosuser

USER rosuser
WORKDIR /home/rosuser

SHELL ["/bin/bash", "-c"]

RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc

HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD ros2 topic list || exit 1

CMD ["/bin/bash", "-c", "source /opt/ros/jazzy/setup.bash && exec ros2 run examples_rclcpp_minimal_publisher publisher_member_function"]
Build Docker Image Locally
docker build -t ros2-jazzy-demo .
Run Container Locally
docker run ros2-jazzy-demo
Azure Container Registry (ACR)

Docker images are securely stored in Azure Container Registry.

Example:

prodacr001.azurecr.io

Images are pushed with:

Immutable build tags
Latest tag

Example:

prodacr001.azurecr.io/ros2-jazzy-demo:15
prodacr001.azurecr.io/ros2-jazzy-demo:latest
Kubernetes Deployment

Kubernetes manifests are located in:

k8s/
├── namespace.yaml
├── deployment.yaml
├── service.yaml
└── ingress.yaml
Deploy Manually
kubectl apply -f k8s/
Verify Deployment
kubectl get pods -n production
kubectl get svc -n production
kubectl get ingress -n production
NGINX Ingress Controller

Ingress controller is installed using Helm.

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace

Ingress provides:

External access
TLS termination
Load balancing
TLS with cert-manager

TLS certificates are automatically generated using Let's Encrypt and cert-manager.

Features
Automatic HTTPS
Automatic certificate renewal
Secure ingress communication

ClusterIssuer is managed through Terraform using Kubernetes manifests.

Security Scanning with Trivy

The pipeline includes container image security scanning using Trivy.

Security Features
Vulnerability scanning
Critical severity blocking
JSON report generation
Artifact publishing

Example scan:

trivy image prodacr001.azurecr.io/ros2-jazzy-demo:latest
Monitoring

Monitoring stack includes:

Prometheus
Grafana
Kubernetes logs
AKS metrics

Installed using Helm:

helm install prometheus prometheus-community/prometheus

helm install grafana grafana/grafana
Logs and Metrics
View ROS2 Logs
kubectl logs deployment/ros2-jazzy-demo -n production
Grafana Dashboards Provide
CPU utilization
Memory usage
Network traffic
Pod health
Cluster metrics
How to Run Locally
Clone Repository
git clone https://github.com/Akankshakumbhare/ros2-jazzy-demo.git
Build Docker Image
docker build -t ros2-jazzy-demo .
Run Container
docker run ros2-jazzy-demo
Deploy to Kubernetes
kubectl apply -f k8s/
Production Features Implemented
Feature	Purpose
Terraform IaC	Automated infrastructure provisioning
Trivy Security Scan	Container vulnerability scanning
Automatic Rollback	Safer deployments
cert-manager	Automatic TLS certificates
NGINX Ingress	Secure traffic routing
ACR Integration	Private image registry
Runtime Validation	ROS2 publisher verification
Azure Policy	AKS governance
OIDC & Workload Identity	Modern AKS authentication
Log Analytics	Centralized logging
Future Improvements
Improvement	Benefit
Helm charts	Reusable Kubernetes deployments
ArgoCD	GitOps continuous delivery
HPA autoscaling	Automatic scaling
SonarQube	Code quality analysis
Azure Monitor	Advanced observability
Multi-stage Docker builds	Smaller container images
Blue-Green Deployment	Zero downtime deployments
Screenshots
AKS Pods

Add screenshot here

Azure DevOps Pipeline

Add screenshot here

Grafana Dashboard

Add screenshot here

Conclusion

This project demonstrates a complete end-to-end enterprise-grade CI/CD implementation for ROS2 Jazzy applications using modern DevOps and cloud-native practices.

The solution provides:

Automated infrastructure provisioning
Automated Docker builds
Container vulnerability scanning
Runtime validation
Kubernetes orchestration
Secure ingress with TLS
Automatic rollback
Centralized monitoring
Scalable cloud-native architecture

The project showcases Infrastructure as Code, Kubernetes deployment automation, container security, and production-ready DevOps workflows on Microsoft Azure.

Project Limitation
The ROS2 publisher container is not an HTTP web application and does not expose a web server on port 80.