
Deploy EKS cluster and install Crossplane in cluster
```
terraform init
terraform plan
terraform apply -auto-approve
```

update kube config
```
aws eks list-clusters --region eu-west-1
{
    "clusters": [
        "crossplane-eks"
    ]
}

aws eks update-kubeconfig --region eu-west-1 --name crossplane-eks
```

Cerate secret for Crossplane
```
kubectl create secret \
generic aws-secret \
-n crossplane-system \
--from-file=creds=<path_to_your_home>/.aws/credentials_crossplane
```

check Helm chart
```
helm ls -n crossplane-system
NAME            NAMESPACE               REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
crossplane      crossplane-system       1               2023-06-23 17:00:59.5481778 +0300 EEST  deployed        crossplane-1.12.2       1.12.2

helm status crossplane -n crossplane-system
NAME: crossplane
LAST DEPLOYED: Fri Jun 23 17:00:59 2023
NAMESPACE: crossplane-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Release: crossplane

Chart Name: crossplane
Chart Description: Crossplane is an open source Kubernetes add-on that enables platform teams to assemble infrastructure from multiple vendors, and expose higher level self-service APIs for application teams to consume.
Chart Version: 1.12.2
Chart Application Version: 1.12.2

Kube Version: v1.27.2-eks-c12679a
```

Check created S3 bucket
```
kubectl get buckets
NAME                   READY   SYNCED   EXTERNAL-NAME          AGE
crossplane-s3-bucket   True    True     crossplane-s3-bucket   19s
```

Delete bucket
```
kubectl delete bucket crossplane-s3-bucket
```
