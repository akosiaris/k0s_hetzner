## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 3.0.2 |
| <a name="requirement_k0s"></a> [k0s](#requirement\_k0s) | 0.2.2 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.5.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.0.2 |
| <a name="provider_k0s"></a> [k0s](#provider\_k0s) | 0.2.2 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.hccm](https://registry.terraform.io/providers/hashicorp/helm/3.0.2/docs/resources/release) | resource |
| [helm_release.hcloud-csi-driver](https://registry.terraform.io/providers/hashicorp/helm/3.0.2/docs/resources/release) | resource |
| [helm_release.local-static-provisioner](https://registry.terraform.io/providers/hashicorp/helm/3.0.2/docs/resources/release) | resource |
| [helm_release.terraform-hcloud-k0s-configs](https://registry.terraform.io/providers/hashicorp/helm/3.0.2/docs/resources/release) | resource |
| [k0s_cluster.k0s](https://registry.terraform.io/providers/alessiodionisi/k0s/0.2.2/docs/resources/cluster) | resource |
| [local_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/2.5.3/docs/resources/file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_controller_addresses"></a> [controller\_addresses](#input\_controller\_addresses) | A map of objects containing IPv4/IPv6 public and private addresses | <pre>map(object({<br/>    public_ipv4  = optional(string),<br/>    public_ipv6  = optional(string),<br/>    private_ipv4 = optional(string),<br/>  }))</pre> | n/a | yes |
| <a name="input_controller_role"></a> [controller\_role](#input\_controller\_role) | The k0s role for a controller. Values: controller, controller+worker, single | `string` | `"controller"` | no |
| <a name="input_cp_balancer_ips"></a> [cp\_balancer\_ips](#input\_cp\_balancer\_ips) | If balancing the control-plane, its IPs | `list(string)` | `[]` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain of all hosts. Will be used to generate all PTRs and names | `string` | n/a | yes |
| <a name="input_externalIPs"></a> [externalIPs](#input\_externalIPs) | Ingress-nginxs externalIPs setting. Needs to match at least the IPs of the workers | `list(string)` | `[]` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | A map of firewall holes. The keys are arbitrary strings, the values objects with proto, ports, cidrs keys | <pre>map(object({<br/>    proto = string<br/>    port  = string<br/>    cidrs = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_hccm_enable"></a> [hccm\_enable](#input\_hccm\_enable) | Whether or not the Hetzner Cloud controller manager will be installed | `bool` | `true` | no |
| <a name="input_hcloud_token"></a> [hcloud\_token](#input\_hcloud\_token) | Value of the Hetzner token | `string` | n/a | yes |
| <a name="input_hcsi_enable"></a> [hcsi\_enable](#input\_hcsi\_enable) | Whether or not the Hetzner CSI (Cloud Storage Interface) will be installed | `bool` | `true` | no |
| <a name="input_hcsi_encryption_key"></a> [hcsi\_encryption\_key](#input\_hcsi\_encryption\_key) | If specified, a Kubernetes StorageClass with LUKS encryption will become available | `string` | `""` | no |
| <a name="input_k0s_version"></a> [k0s\_version](#input\_k0s\_version) | The version of k0s to target | `string` | n/a | yes |
| <a name="input_ssh_priv_key_path"></a> [ssh\_priv\_key\_path](#input\_ssh\_priv\_key\_path) | The private part of the above | `string` | n/a | yes |
| <a name="input_worker_addresses"></a> [worker\_addresses](#input\_worker\_addresses) | A map of objects containing IPv4/IPv6 public and private addresses. Defaults to empty map | <pre>map(object({<br/>    public_ipv4  = optional(string),<br/>    public_ipv6  = optional(string),<br/>    private_ipv4 = optional(string),<br/>  }))</pre> | `{}` | no |

## Outputs

No outputs.
