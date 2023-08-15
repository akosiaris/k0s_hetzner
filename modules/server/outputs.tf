output "addresses" {
  value = {
    for s in hcloud_server.server :
    s.name => {
      public_ipv4 = s.ipv4_address,
      public_ipv6 = s.ipv6_address,
      # TODO: This is ugly and pretty meh, we probably can do better
      # Note that the tostring() calls are to make sure we compare strings, cause it can be that one of the arguments is an int
      private_ipv4 = one(
        [
          for n in hcloud_server_network.privnet.* :
          n.ip if tostring(n.server_id) == tostring(s.id)
        ]
      )
    }
  }
}
