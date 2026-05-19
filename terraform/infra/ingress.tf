resource "helm_release" "nginx_ingress" {
  name             = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    kubernetes_namespace.production
  ]

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
}