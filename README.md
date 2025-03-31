# 🚀 Módulo Terraform AWS EKS VPC

Este módulo provisiona uma VPC configurada para uso com o Amazon EKS (Elastic Kubernetes Service), seguindo as melhores práticas da AWS. Ideal para ambientes de produção, ele cria sub-redes públicas e privadas, NAT Gateway, Internet Gateway, tabelas de rotas e aplica as tags exigidas para integração com o EKS.

---

## 📦 Recursos Criados

Este módulo cria os seguintes recursos da AWS:

- **VPC**: Uma Virtual Private Cloud com suporte a DNS e nomes de host DNS habilitados
- **Sub-redes**: públicas e privadas para o cluster EKS
- **Gateway de Internet**: para comunicação entre a VPC e a internet
- **Gateway NAT**: para acesso à internet em sub-redes privadas
- **Tabelas de Rotas**: para gerenciar o tráfego da VPC

---

## 🔧 Variáveis de Entrada

| Nome                  | Descrição                                                 | Tipo     | Padrão         | Obrigatório |
|-----------------------|-----------------------------------------------------------|----------|----------------|:-----------:|
| `cidr_block`          | O bloco CIDR para a VPC                                   | `string` | `"10.0.0.0/16"`      | não |
| `project_name`        | O nome do projeto (usado para nomear recursos)            | `string` | `"Lucas-EKS-Module"` | não |
| `cluster_name`        | O nome do cluster EKS                                     | `string` | `"Lucas-EKS-Module"` | não |
| `number_of_subnets`   | O número de sub-redes públicas e privadas a serem criadas | `number` | `3`                  | não |
| `tag_private_subnets` | O valor da tag para função ELB interna do Kubernetes      | `number` | `1`                  | não |
| `tag_public_subnets`  | O valor da tag para função ELB do Kubernetes              | `number` | `1`                  | não |

---

### Personalização para Diferentes Ambientes

Para diferentes ambientes (desenvolvimento, homologação, produção), você pode personalizar o módulo ajustando as seguintes variáveis:

- **Desenvolvimento**: Use blocos CIDR menores e reduza o número de sub-redes usando a variável `number_of_subnets`
- **Homologação**: Espelhe a produção, mas com convenções de nomenclatura diferentes
- **Produção**: Use os padrões ou expanda o intervalo CIDR conforme necessário para implantações maiores e aumente o número de sub-redes se precisar de mais redundância

---

## 📤 Saídas

| Nome | Descrição |
|------|-----------|
| `vpc_id` | O ID da VPC |
| `public_subnets` | Lista de IDs das sub-redes públicas |
| `private_subnets` | Lista de IDs das sub-redes privadas |

Essas saídas podem ser referenciadas em outros módulos ou recursos do Terraform usando a sintaxe padrão de saída do Terraform.

---

## 💻 Exemplos de Uso

### Uso Básico

```hcl
locals {
  eks_variables = {
    cluster_name   = "Lucas-EKS-Module"
    desired_size   = 1
    max_size       = 2
    min_size       = 1
    instance_types = ["t3.medium"]
    capacity_type  = "SPOT"
    disk_size      = 50
  }
}

module "eks" {
  source          = "./modules/eks"
  private_subnets = 
  desired_size    = local.eks_variables.desired_size
  max_size        = local.eks_variables.max_size
  min_size        = local.eks_variables.min_size
  instance_types  = local.eks_variables.instance_types
  capacity_type   = local.eks_variables.capacity_type
  disk_size       = local.eks_variables.disk_size
}

```