provider "kubernetes" {
  config_context_cluster = "arn:aws:eks:ap-south-1:383611100557:cluster/ekscluster"
}
resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wp1"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app="wordpress"
      }
    }
    template {
      metadata {
        labels = {
        app="wordpress"
        }
      }
      spec {
        container {
          image = "wordpress"
          name  = "wp1"
        }
      }
    }
  }
}
resource "kubernetes_service" "wordpress" {
  metadata {
    name = "wp1"
  }
  spec {
    selector = {
      app = "wordpress"
    }
    
    port {
      port        = 80
    }
    type = "LoadBalancer"
  }
}

