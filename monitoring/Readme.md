# Monitoring Setup

The Kubernetes cluster monitoring stack was implemented using:

* Prometheus for metrics collection
* Grafana for visualization
* Kubernetes logs for application troubleshooting

## Components Installed

* Prometheus Helm Chart
* Grafana Helm Chart

## Installation Commands

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

helm install prometheus prometheus-community/prometheus

helm install grafana grafana/grafana
```

## Metrics Monitored

* Pod CPU usage
* Memory usage
* Pod restart count
* Node health
* Kubernetes pod status

## Application Logs

```bash
kubectl logs deployment/ros2-publisher
```

## Grafana Dashboard

Grafana dashboards were configured using Prometheus datasource to visualize Kubernetes metrics.
## Monitoring Dashboard

![Grafana Dashboard](monitoring/grafana-dashboard.png)