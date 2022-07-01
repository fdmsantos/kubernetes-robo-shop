# ======================= GITHUB =========================
#
# SSH Deploy Key to use by Flux CD
resource "tls_private_key" "main" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "main" {
  title      = var.name_prefix
  repository = var.git_repository_name
  key        = tls_private_key.main.public_key_openssh
  read_only  = true
}
# =========================================================

# =========================== FLUX CD ===========================
resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

resource "kubectl_manifest" "install" {
  for_each   = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

resource "kubectl_manifest" "sync" {
  for_each   = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

resource "kubernetes_secret" "main" {
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = data.flux_sync.main.secret
    namespace = data.flux_sync.main.namespace
  }

  data = {
    identity       = tls_private_key.main.private_key_pem
    "identity.pub" = tls_private_key.main.public_key_pem
    known_hosts    = "github.com ${var.github_ssh_pub_key}"
  }
}

resource "kubernetes_config_map" "flux-vars" {
  depends_on = [kubernetes_namespace.flux_system]
  metadata {
    name      = "flux-infra-variables"
    namespace = data.flux_sync.main.namespace
    annotations = {
      "kustomize.toolkit.fluxcd.io/ssa" = "merge"
    }
  }

  data = {
    istio_version = var.istio_verion
    kiali_version = var.kiali_verion
  }
}
# ==================================================================