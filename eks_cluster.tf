module "eks"{
    source = "terraform-aws-modules/eks/aws"
    version                         = "19.15.3"
    cluster_name                    = local.cluster_name
    cluster_version                 = "1.27"
    cluster_endpoint_private_access = false
    cluster_endpoint_public_access  = true
    enable_irsa                     = true
    vpc_id                          = module.vpc.vpc_id
    subnet_ids                      = module.vpc.private_subnets

    tags = {
            Name  = "${ var.project }-eks"
            Owner = "Ilia Eriomenco"
        }

    eks_managed_node_group_defaults = {}

    eks_managed_node_groups = {
        "workloads" = {
        min_size       = 1
        max_size       = 3
        desired_size   = 1
        capacity_type  = "SPOT"
        instance_types = ["t2.small"]
        labels = {
            Type        = "managed_node_group"
            Provisioner = "terraform-aws-eks"
            Usage       = "workloads"
        }

        tags = {
            ExtraTag = "workloads"
        }
        }
    }
}


