resource "helm_release" "crossplane" {
  name       = "crossplane"
  namespace  = "crossplane-system"
  repository = "https://charts.crossplane.io/stable"
  chart      = "crossplane"
  create_namespace = true

  depends_on = [
    module.eks
  ]
}

resource "kubectl_manifest" "provider" {
    yaml_body = <<YAML
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: upbound-provider-aws
spec:
  package: xpkg.upbound.io/upbound/provider-aws:v0.27.0
YAML

  depends_on = [
    helm_release.crossplane
  ]
}

# resource "kubectl_manifest" "secret" {
#     yaml_body = <<YAML
# apiVersion: v1
# kind: Secret
# metadata:
#   name: aws-secret
#   namespace: crossplane-system
# type: Opaque
# from-file: ~/.aws/credentials_crossplane
# data:
#   creds: 
# YAML

#   depends_on = [
#     kubectl_manifest.provider
#   ]
# }

resource "kubectl_manifest" "providerconfig" {
    yaml_body = <<YAML
apiVersion: aws.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: aws-secret
      key: creds
YAML
}

resource "kubectl_manifest" "s3_bucket" {
    yaml_body = <<YAML
apiVersion: s3.aws.upbound.io/v1beta1
kind: Bucket
metadata:
  name: ${var.project}-s3-bucket
spec:
  forProvider:
    region: ${var.region}
  providerConfigRef:
    name: default
YAML
}


