module vpc {
    source = "terraform-aws-modules/vpc/aws"
   
    name = "${ var.project }-vpc"
    cidr = "10.0.0.0/16"
    
    azs = data.aws_availability_zones.available.names
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets =  ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
    
    enable_nat_gateway = true
    single_nat_gateway = true
    
    enable_dns_hostnames= true
    tags = {
        "Name" = "${ var.project }-vpc"
        "Owner"= "Ilia Eriomenco"
    }
    public_subnet_tags = {
        "Name" = "${ var.project }-public-subnet"
        "Owner"= "Ilia Eriomenco"
    }
    private_subnet_tags = {
        "Name" = "${ var.project }-private-subnet"
        "Owner"= "Ilia Eriomenco"
    }
}