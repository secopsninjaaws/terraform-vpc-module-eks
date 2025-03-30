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
module "eks_vpc" {
  source = "./modules/vpc"

  cidr_block    = "10.0.0.0/16"
  project_name  = "my-eks-project"
  cluster_name  = "production-cluster"
}

output "vpc_id" {
  value = module.eks_vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.eks_vpc.private_subnets
}