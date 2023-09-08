<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | 1.42.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | 1.42.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [hcloud_firewall.firewall](https://registry.terraform.io/providers/hetznercloud/hcloud/1.42.1/docs/resources/firewall) | resource |
| [hcloud_firewall_attachment.firewall_attachment](https://registry.terraform.io/providers/hetznercloud/hcloud/1.42.1/docs/resources/firewall_attachment) | resource |
| [hcloud_placement_group.pg](https://registry.terraform.io/providers/hetznercloud/hcloud/1.42.1/docs/resources/placement_group) | resource |
| [hcloud_server.server](https://registry.terraform.io/providers/hetznercloud/hcloud/1.42.1/docs/resources/server) | resource |
| [hcloud_server_network.privnet](https://registry.terraform.io/providers/hetznercloud/hcloud/1.42.1/docs/resources/server_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amount"></a> [amount](#input\_amount) | The number of servers | `number` | n/a | yes |
| <a name="input_datacenter"></a> [datacenter](#input\_datacenter) | The Hetzner datacenter name to create the server in. Values: nbg1-dc3, fsn1-dc14, hel1-dc2, ash-dc1, hil-dc1. Defaults to fsn1-dc14 | `string` | `"fsn1-dc14"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain of all hosts. Will be used to generate all PTRs | `string` | n/a | yes |
| <a name="input_enable_network"></a> [enable\_network](#input\_enable\_network) | Enable a Hetzner private network | `bool` | `false` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | A map of firewall holes. The keys are arbitrary strings, the values objects with proto, ports, cidrs keys | <pre>map(object({<br>    proto = string<br>    port  = string<br>    cidrs = list(string)<br>  }))</pre> | `{}` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | You can override the generated name to one of your choose. Only use if spawning up a single server | `string` | `null` | no |
| <a name="input_image"></a> [image](#input\_image) | The Hetzner cloud server image. Values: debian-11, debian-12. Defaults to debian-12 | `string` | `"debian-12"` | no |
| <a name="input_ip_address_ids"></a> [ip\_address\_ids](#input\_ip\_address\_ids) | A map of AF\_INET family and list of terraform primary\_ip ids | `map(list(number))` | n/a | yes |
| <a name="input_network_subnet_id"></a> [network\_subnet\_id](#input\_network\_subnet\_id) | The Hetzner private network subnet id. It should be the one obtained by a call to the child network module | `string` | `null` | no |
| <a name="input_role"></a> [role](#input\_role) | The role of the server. It will be set in labels | `string` | n/a | yes |
| <a name="input_ssh_priv_key_path"></a> [ssh\_priv\_key\_path](#input\_ssh\_priv\_key\_path) | The private part of the above | `string` | n/a | yes |
| <a name="input_ssh_pub_key_id"></a> [ssh\_pub\_key\_id](#input\_ssh\_pub\_key\_id) | The terraform id of SSH key for connecting to servers | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | The Hetzner cloud server type. Defaults to cax11 | `string` | `"cax11"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_addresses"></a> [addresses](#output\_addresses) | n/a |
<!-- END_TF_DOCS -->