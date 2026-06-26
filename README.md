# 🛒 Online E-commerce
 
Este es un proyecto de infraestructura en aws que aplica conceptos de terraform, docker, y elementos en la nube. 

## 🚀 Objetivo

Construir la infraestructura necesaria para soportar sitio de E-commerce y una base de datos vinculada al mismo. Esta debe ser resiliente y escalable para el sitio web, teniendo en cuenta la seguridad y facilidad para el usuario que usa el repositorio. 

## 🔧 Configuración necesaria en Linux RH

### Instalar git, awscli y terraform

``` bash
sudo yum install -y git
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum install -y terraform
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### Configurar credenciales en awscli 

``` shell
aws configure
```

### Bajar el repositorio, moverse al directorio terraform y desplegar la infraestructura

```shell 
git clone https://github.com/AA241131/ISC-Obligatorio
cd ISC-Obligatorio/terraform
terraform init
terraform plan
terraform apply -auto-approve
```

### Estructura del Proyecto

``` shell 
└── ISC-Obligatorio
    ├── e-commerce                            # applicacion
    ├── README.md                             # este archivo
    └── terraform                             # instrucciones de despliegue
        ├── main.tf                           # root main
        ├── modules
        │   ├── autoscaling-module
        │   ├── ec2-module
        │   ├── rds-module
        │   ├── s3-module
        │   ├── sec-module
        │   └── vpc-module
        ├── output.tf
        ├── user_data_bastion.tpl    
        ├── user_data.launch_template.tpl
        ├── valores.auto.tfvars
        └── variables.tf

```

## Credenciales de Admin en la app

```sh
uri: /admin/login
username: admin
password: 123456
```

