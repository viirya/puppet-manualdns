#
class manualdns ($domain_servers = "127.0.0.1", $search_domain = "openstacklocal") {

    file { "/etc/resolvconf/resolv.conf.d/base":
        ensure => present,
        content => template("manualdns/resolv_base.erb"),
        before => Exec["modify-dhclient"],
    }

    exec { "modify dhclient.conf":
        command => "sed -i s/domain-name-servers//g /etc/dhcp/dhclient.conf ; sed -i s/\(dhcp6.\)\?domain-search//g /etc/dhcp/dhclient.conf",
        alias => "modify-dhclient",
        path    => ["/bin", "/usr/bin", "/usr/sbin"],
        notify => [Service["networking"], Exec["update-resolv"]],
    }

    service { "networking":
        ensure  => "running",
        enable  => "true",
    }

    exec { "update resolv.con":
        command => "resolvconf -u",
        user => "root",
        alias => "update-resolv",
        path => ["/bin", "/usr/bin", "/usr/sbin", "/sbin"],
    }

}
