## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | 1.52.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | 1.52.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [hcloud_load_balancer.lb](https://registry.terraform.io/providers/hetznercloud/hcloud/1.52.0/docs/resources/load_balancer) | resource |
| [hcloud_load_balancer_network.lb_privnet](https://registry.terraform.io/providers/hetznercloud/hcloud/1.52.0/docs/resources/load_balancer_network) | resource |
| [hcloud_load_balancer_service.service](https://registry.terraform.io/providers/hetznercloud/hcloud/1.52.0/docs/resources/load_balancer_service) | resource |
| [hcloud_load_balancer_target.extra](https://registry.terraform.io/providers/hetznercloud/hcloud/1.52.0/docs/resources/load_balancer_target) | resource |
| [hcloud_load_balancer_target.target](https://registry.terraform.io/providers/hetznercloud/hcloud/1.52.0/docs/resources/load_balancer_target) | resource |
| [hcloud_network.privnet](https://registry.terraform.io/providers/hetznercloud/hcloud/1.52.0/docs/resources/network) | resource |
| [hcloud_network_subnet.privnet_subnet](https://registry.terraform.io/providers/hetznercloud/hcloud/1.52.0/docs/resources/network_subnet) | resource |
| [hcloud_primary_ip.ipv4](https://registry.terraform.io/providers/hetznercloud/hcloud/1.52.0/docs/resources/primary_ip) | resource |
| [hcloud_primary_ip.ipv6](https://registry.terraform.io/providers/hetznercloud/hcloud/1.52.0/docs/resources/primary_ip) | resource |
| [hcloud_rdns.ipv4](https://registry.terraform.io/providers/hetznercloud/hcloud/1.52.0/docs/resources/rdns) | resource |
| [hcloud_rdns.ipv6](https://registry.terraform.io/providers/hetznercloud/hcloud/1.52.0/docs/resources/rdns) | resource |
| [hcloud_rdns.lb_ipv4](https://registry.terraform.io/providers/hetznercloud/hcloud/1.52.0/docs/resources/rdns) | resource |
| [hcloud_rdns.lb_ipv6](https://registry.terraform.io/providers/hetznercloud/hcloud/1.52.0/docs/resources/rdns) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amount"></a> [amount](#input\_amount) | The number of servers | `number` | n/a | yes |
| <a name="input_balanced_extraIPs"></a> [balanced\_extraIPs](#input\_balanced\_extraIPs) | A list of IPs belonging to non terraform managed resources that are going to be members of the k0s cluster | `list(string)` | `[]` | no |
| <a name="input_balanced_protocol"></a> [balanced\_protocol](#input\_balanced\_protocol) | The load balanced protocol | `string` | `"tcp"` | no |
| <a name="input_balanced_services"></a> [balanced\_services](#input\_balanced\_services) | The ports that will get load balanced. NOTE: currently listen and dest port need to be the same | `list(number)` | <pre>[<br/>  6443,<br/>  8132,<br/>  9443<br/>]</pre> | no |
| <a name="input_balancer_type"></a> [balancer\_type](#input\_balancer\_type) | The load balancer type to deploy in front of the created IPs | `string` | `"lb11"` | no |
| <a name="input_datacenter"></a> [datacenter](#input\_datacenter) | The Hetzner datacenter name to create the server in. Values: nbg1-dc3, fsn1-dc14, hel1-dc2, ash-dc1, hil-dc1. Defaults to fsn1-dc14 | `string` | `"fsn1-dc14"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain of all hosts. Will be used to generate all PTRs | `string` | n/a | yes |
| <a name="input_enable_balancer"></a> [enable\_balancer](#input\_enable\_balancer) | Whether a balancer should be allocated | `bool` | `false` | no |
| <a name="input_enable_ipv4"></a> [enable\_ipv4](#input\_enable\_ipv4) | Whether an IPv4 address should be allocated | `bool` | `true` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Whether an IPv6 address should be allocated | `bool` | `true` | no |
| <a name="input_enable_network"></a> [enable\_network](#input\_enable\_network) | Enable a Hetzner private network | `bool` | `false` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | You can override the generated name to one of your choose. Only use if spawning up a single server | `string` | `null` | no |
| <a name="input_network_ip_range"></a> [network\_ip\_range](#input\_network\_ip\_range) | A CIDR in the RFC1918 space for the Hetzner private network. This is an umbrella entity, don't be frugal | `string` | `"10.100.0.0/16"` | no |
| <a name="input_network_subnet_ip_range"></a> [network\_subnet\_ip\_range](#input\_network\_subnet\_ip\_range) | A CIDR in the RFC1918 space for the Hetzner private network subnet. This needs to be part of the network\_ip\_range | `string` | `"10.100.1.0/24"` | no |
| <a name="input_network_subnet_type"></a> [network\_subnet\_type](#input\_network\_subnet\_type) | Either cloud of vswitch. vswitch is only possible if you also have a Hetzner Robot vswitch | `string` | `"cloud"` | no |
| <a name="input_network_vswitch_id"></a> [network\_vswitch\_id](#input\_network\_vswitch\_id) | ID of the vswitch, Required if type is vswitch | `number` | `null` | no |
| <a name="input_network_zone"></a> [network\_zone](#input\_network\_zone) | The Hetzner network zone. Default to eu-central. | `string` | `"eu-central"` | no |
| <a name="input_role"></a> [role](#input\_role) | The role of the server. It will be set in labels | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address_ids"></a> [address\_ids](#output\_address\_ids) | n/a |
| <a name="output_addresses"></a> [addresses](#output\_addresses) | n/a |
| <a name="output_lb_addresses"></a> [lb\_addresses](#output\_lb\_addresses) | n/a |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | n/a |
