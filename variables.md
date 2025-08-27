## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | 1.52.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | 1.52.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.3 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_controller_ips"></a> [controller\_ips](#module\_controller\_ips) | ./modules/network | n/a |
| <a name="module_controllers"></a> [controllers](#module\_controllers) | ./modules/server | n/a |
| <a name="module_k0s"></a> [k0s](#module\_k0s) | ./modules/k0s | n/a |
| <a name="module_worker_ips"></a> [worker\_ips](#module\_worker\_ips) | ./modules/network | n/a |
| <a name="module_workers"></a> [workers](#module\_workers) | ./modules/server | n/a |

## Resources

| Name | Type |
|------|------|
| [hcloud_ssh_key.terraform-hcloud-k0s](https://registry.terraform.io/providers/hetznercloud/hcloud/1.52.0/docs/resources/ssh_key) | resource |
| [local_file.ssh_priv_key_path](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [tls_private_key.ed25519](https://registry.terraform.io/providers/hashicorp/tls/4.1.0/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_balance_control_plane"></a> [balance\_control\_plane](#input\_balance\_control\_plane) | Whether the control plane will be load balanced. Needs > 1 controller | `bool` | `false` | no |
| <a name="input_balance_worker_plane"></a> [balance\_worker\_plane](#input\_balance\_worker\_plane) | Whether the control plane will be load balanced. Needs > 1 worker | `bool` | `false` | no |
| <a name="input_controller_count"></a> [controller\_count](#input\_controller\_count) | The number of controllers. Defaults to 3 | `number` | `3` | no |
| <a name="input_controller_role"></a> [controller\_role](#input\_controller\_role) | The k0s role for a controller. Values: controller, controller+worker, single | `string` | `"controller"` | no |
| <a name="input_controller_server_datacenter"></a> [controller\_server\_datacenter](#input\_controller\_server\_datacenter) | The Hetzner datacenter name to create the server in. Values: nbg1-dc3, fsn1-dc14, hel1-dc2, ash-dc1 or hil-dc1 | `string` | `"fsn1-dc14"` | no |
| <a name="input_controller_server_image"></a> [controller\_server\_image](#input\_controller\_server\_image) | The Hetzner cloud server image. Values: debian-11, debian-12, debian-13 | `string` | `"debian-13"` | no |
| <a name="input_controller_server_type"></a> [controller\_server\_type](#input\_controller\_server\_type) | The Hetzner cloud server type. Values: cax11, cax21, cax31, cax41 (all ARM64) | `string` | `"cax11"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain of all hosts. Will be used to generate all PTRs and names | `string` | n/a | yes |
| <a name="input_enable_ipv4"></a> [enable\_ipv4](#input\_enable\_ipv4) | Whether an IPv4 address should be allocated | `bool` | `true` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Whether an IPv6 address should be allocated | `bool` | `true` | no |
| <a name="input_enable_private_network"></a> [enable\_private\_network](#input\_enable\_private\_network) | Whether to enable a Hetzner private network interconnecting all nodes or not | `bool` | `false` | no |
| <a name="input_extra_workers"></a> [extra\_workers](#input\_extra\_workers) | A map of objects containing IPv4/IPv6 public and private addresses. Use it to add workers that aren't terraform resources, e.g. baremetal servers | <pre>map(object({<br/>    public_ipv4  = optional(string),<br/>    public_ipv6  = optional(string),<br/>    private_ipv4 = optional(string),<br/>  }))</pre> | `{}` | no |
| <a name="input_hccm_enable"></a> [hccm\_enable](#input\_hccm\_enable) | Whether or not the Hetzner Cloud controller manager will be installed | `bool` | `true` | no |
| <a name="input_hcloud_token"></a> [hcloud\_token](#input\_hcloud\_token) | Value of the Hetzner token | `string` | n/a | yes |
| <a name="input_hcsi_enable"></a> [hcsi\_enable](#input\_hcsi\_enable) | Whether or not the Hetzner CSI (Cloud Storage Interface) will be installed | `bool` | `true` | no |
| <a name="input_hcsi_encryption_key"></a> [hcsi\_encryption\_key](#input\_hcsi\_encryption\_key) | If specified, a Kubernetes StorageClass with LUKS encryption will become available | `string` | `""` | no |
| <a name="input_k0s_version"></a> [k0s\_version](#input\_k0s\_version) | The version of k0s to target | `string` | `"1.33.4+k0s.0"` | no |
| <a name="input_network_ip_range"></a> [network\_ip\_range](#input\_network\_ip\_range) | A CIDR in the RFC1918 space for the Hetzner private network. This is an umbrella entity, don't be frugal | `string` | `"10.100.0.0/16"` | no |
| <a name="input_network_subnet_ip_range"></a> [network\_subnet\_ip\_range](#input\_network\_subnet\_ip\_range) | A CIDR in the RFC1918 space for the Hetzner private network subnet. This needs to be part of the network\_ip\_range | `string` | `"10.100.1.0/24"` | no |
| <a name="input_network_subnet_type"></a> [network\_subnet\_type](#input\_network\_subnet\_type) | Either cloud of vswitch. vswitch is only possible if you also have a Hetzner Robot vswitch | `string` | `"cloud"` | no |
| <a name="input_network_vswitch_id"></a> [network\_vswitch\_id](#input\_network\_vswitch\_id) | ID of the vswitch, Required if type is vswitch | `number` | `null` | no |
| <a name="input_network_zone"></a> [network\_zone](#input\_network\_zone) | The Hetzner network zone. Stick to eu-central for now | `string` | `"eu-central"` | no |
| <a name="input_single_controller_hostname"></a> [single\_controller\_hostname](#input\_single\_controller\_hostname) | If you are deploying using a single role, it's probably a pet. Name it | `string` | `null` | no |
| <a name="input_ssh_priv_key_path"></a> [ssh\_priv\_key\_path](#input\_ssh\_priv\_key\_path) | The private SSH for connecting to servers. If left empty, terraform will create a key pair for you | `string` | `null` | no |
| <a name="input_ssh_pub_key"></a> [ssh\_pub\_key](#input\_ssh\_pub\_key) | Public SSH key for connecting to servers. If left empty, terraform will create a key pair for you | `string` | `null` | no |
| <a name="input_worker_count"></a> [worker\_count](#input\_worker\_count) | The number of workers. Defaults to 3 | `number` | `3` | no |
| <a name="input_worker_server_datacenter"></a> [worker\_server\_datacenter](#input\_worker\_server\_datacenter) | The Hetzner datacenter name to create the server in. Values: nbg1-dc3, fsn1-dc14, hel1-dc2, ash-dc1 or hil-dc1 | `string` | `"fsn1-dc14"` | no |
| <a name="input_worker_server_image"></a> [worker\_server\_image](#input\_worker\_server\_image) | The Hetzner cloud server image. Values: debian-11, debian-12 | `string` | `"debian-12"` | no |
| <a name="input_worker_server_type"></a> [worker\_server\_type](#input\_worker\_server\_type) | The Hetzner cloud server type. Values: cax11, cax21, cax31, cax41 (all ARM64) | `string` | `"cax11"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_controller_ip_addresses"></a> [controller\_ip\_addresses](#output\_controller\_ip\_addresses) | n/a |
| <a name="output_lb_ip_addresses"></a> [lb\_ip\_addresses](#output\_lb\_ip\_addresses) | n/a |
| <a name="output_worker_ip_addresses"></a> [worker\_ip\_addresses](#output\_worker\_ip\_addresses) | n/a |
