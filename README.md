# Plan with 
 terraform plan -var-file luminor_eks.tfvars

# Run with
 terraform apply -var-file luminor_eks.tfvars

 # Notes
1. I've set up an environment file for the EKS so can be used on a diversity of environments such as Dev, Staging, Prod.

2. By convenience I've setup the loadbalancer in the service, just to make it run, ideally it will be setup in the ingress.

4. I left, many open passwords (I know), I could have used Hashicorp Vault but I had no time. 

5. Variables in `helm.tf`could have been in place but same as secrets (no time).

6. By default Atlantis will not have ``aws-cli`` installed so you might need to set a new image (check in ``files/atlantis.dockerfile``) to be able to run Atlantis adding the following setting to the helm provider.
    ```   
    set {
        name = "image.repository"
        value = ""
    }
    ```
    Later it will be able to get the EKS credentials and run all the helm tasks as I've seen in my local environment. 
