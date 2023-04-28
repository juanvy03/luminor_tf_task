provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

resource "helm_release" "nginx-ingress-controller" {
  name       = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"


  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}

resource "helm_release" "atlantis" {
  name       = "runatlantis"
  repository = "https://runatlantis.github.io/helm-charts"
  chart      = "atlantis"


  set {
    name = "orgAllowlist"
    value =  "github.com/juanvy03/*"
  }

  set {
    name = "github.user"
    value = "juanvy03"
  }

  set {
    name = "github.token"
    #value = "atlantis_cicd"
    value = "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"
  }

  set {
    name = "github.secret"
    value = "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"
  }

  set {
    name = "aws.credentials"
    value = <<E
        [default]
        aws_access_key_id=AKIAR3INXM7A3SSWWLE5
        aws_secret_access_key=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
        region=eu-central-1"
        E
  }

  set {
    name = "ingress.ingressClassName"
    value = "nginx"
  }

  set {
    name = "service.type"
    value = "LoadBalancer"
  }

  set {
    name = "repoConfig"
    value = <<EOF
              ---
              repos:
              - id: /.*/
                workflow: test
                allowed_overrides: []
                allow_custom_workflows: false
              workflows:
                test:
                  plan:
                    steps:
                    - init
                    - plan:
                        extra_args: [\"\-var-file\"\,\"\luminor_eks.tfvars\"\]
                  apply:
                    steps:
                    - apply:
                        extra_args: [\"\-var-file\"\,\"\luminor_eks.tfvars\"\]
            EOF
  }
}
