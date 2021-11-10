### Usage

Initialize the project, which downloads a plugin that allows Terraform to interact with it's resources.

```bash
terraform init
```

Run ```plan``` to verify the creation and deletion of resources.

```bash
terraform plan -var-file=configs.tfvars
```

Provision the K3s cluster and all necessary resources with `apply`. When Terraform asks you to confirm type `yes` and press `ENTER`.
```bash
terraform apply -var-file=configs.tfvars
```

For multiple environments, you can change the terraform workspace and update the necessary resources and deploy the cluster.

```bash
terraform workspace list
terraform workspace new qa
terraform apply -var-file=configs.tfvars
```