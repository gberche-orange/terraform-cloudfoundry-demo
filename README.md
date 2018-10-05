
# tf-cf-demo

This repo supports demo of the [terraform-provider-cloudfoundry](https://github.com/mevansam/terraform-provider-cf) on Ubuntu 64 bits. Refer to https://www.terraform.io/intro/getting-started/install.html and https://github.com/mevansam/terraform-provider-cf#using-the-provider appropriate steps for your platform.  

## Install terraform and provider


```sh
curl -LO https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip
unzip terraform_0.11.8_linux_amd64.zip
#add binary to your path

./terraform -version
./terraform
 
mkdir -p $HOME/terraform.d/plugins/linux_amd64
curl -L https://github.com/mevansam/terraform-provider-cf/releases/download/0.9.9/terraform-provider-cf_linux_amd64 -o $HOME/terraform.d/plugins/linux_amd64/terraform-provider-cloudfoundry 
```

## Configure intellij

Install the [hashicorp-terraform--hcl-language-support](https://plugins.jetbrains.com/plugin/7808-hashicorp-terraform--hcl-language-support) plugin

Install the schema for the terraform-provider-cloudfoundry (temporary step until the provider becomes official, see https://github.com/VladRassokhin/intellij-hcl/issues/128)


```sh
mkdir -p $HOME/terraform.d/schemas
cp cloudfoundry.json $HOME/terraform.d/schemas 
```

Restart intellij
