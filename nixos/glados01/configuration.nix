{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  frrConfig = builtins.readFile ./frr.conf;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common.nix
    ../users.nix
  ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      efiSupport = true;
      device = "nodev";
      memtest86.enable = true;
      configurationLimit = 12;
      extraConfig = ''
        serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
        terminal_input --append serial
        terminal_output --append serial
      '';
    };
  };

  boot.kernel = {
    sysctl = {
      "net.ipv4.conf.all.forwarding" = true;
      "net.ipv6.conf.all.forwarding" = true;
      # Accept RA on eno1 even with forwarding enabled (2 = accept even as router)
      "net.ipv6.conf.eno1.accept_ra" = 2;
      # Enable SLAAC on eno1
      "net.ipv6.conf.eno1.autoconf" = 1;
      # Drop martian packets
      "net.ipv4.conf.default.rp_filter" = 1;

      # 10G TCP tuning - larger buffers for high bandwidth-delay product
      "net.core.rmem_max" = 16777216; # 16MB max receive buffer
      "net.core.wmem_max" = 16777216; # 16MB max send buffer
      "net.core.rmem_default" = 1048576; # 1MB default receive buffer
      "net.core.wmem_default" = 1048576; # 1MB default send buffer
      "net.ipv4.tcp_rmem" = "4096 1048576 16777216"; # min/default/max
      "net.ipv4.tcp_wmem" = "4096 1048576 16777216";
      "net.core.netdev_max_backlog" = 5000; # increased for 10G
      "net.core.netdev_budget" = 600; # NAPI budget for high throughput
    };
  };

  # Keep CPU at max frequency for consistent routing performance
  powerManagement.cpuFreqGovernor = "performance";

  boot.kernelParams = [
    "console=tty1"
    "console=ttyS0,115200"
    "earlyprintk=ttyS0,115200"
  ];

  systemd.services."serial-getty@ttyS0" = {
    enable = true;
    wantedBy = [ "getty.target" ]; # to start at boot
    serviceConfig.Restart = "always"; # restart when session is closed
  };

  # TODO Turn this into an option
  networking.hostName = "glados01";
  networking.enableIPv6 = true;

  # Prevent dhcpcd from assigning IPv4 link-local to overlay interfaces
  networking.dhcpcd.denyInterfaces = [
    "vrf-*"
    "vxlan*"
    "br-cell*"
  ];

  networking.interfaces = {
    lo = {
      ipv4.addresses = [
        {
          address = "10.255.0.1";
          prefixLength = 32;
        }
      ];
    };
    eno1 = {
      mtu = 9000;
      ipv4.addresses = [
        {
          address = "10.0.2.1";
          prefixLength = 24;
        }
        {
          # VIP for management k8s cluster API server
          address = "10.0.2.10";
          prefixLength = 24;
        }
      ];
    };
    eno3 = {
      ipv4.addresses = [
        {
          address = "192.168.15.10";
          prefixLength = 24;
        }
      ];
    };
  };

  networking.defaultGateway = {
    address = "192.168.15.1";
    interface = "eno3";
  };

  networking.nameservers = [ "192.168.15.1" ];

  # Enable systemd-networkd for VRF/VXLAN support
  systemd.network.enable = true;

  # Disable wait-online - main interfaces use scripted networking, not networkd
  systemd.network.wait-online.enable = false;

  # VRF netdevs
  systemd.network.netdevs = {
    "10-vrf-cell1" = {
      netdevConfig = {
        Name = "vrf-cell1";
        Kind = "vrf";
      };
      vrfConfig.Table = 1001;
    };
    "10-vrf-cell2" = {
      netdevConfig = {
        Name = "vrf-cell2";
        Kind = "vrf";
      };
      vrfConfig.Table = 2001;
    };
    "10-vrf-cell3" = {
      netdevConfig = {
        Name = "vrf-cell3";
        Kind = "vrf";
      };
      vrfConfig.Table = 3001;
    };
    # Bridge netdevs for L2 VNIs (VM traffic, Type-2/Type-3)
    "15-br-cell1" = {
      netdevConfig = {
        Name = "br-cell1";
        Kind = "bridge";
        MTUBytes = "8950";
      };
    };
    "15-br-cell2" = {
      netdevConfig = {
        Name = "br-cell2";
        Kind = "bridge";
        MTUBytes = "8950";
      };
    };
    "15-br-cell3" = {
      netdevConfig = {
        Name = "br-cell3";
        Kind = "bridge";
        MTUBytes = "8950";
      };
    };
    # L2 VXLAN netdevs for bridging (Type-2/Type-3 routes)
    "20-vxlan100" = {
      netdevConfig = {
        Name = "vxlan100";
        Kind = "vxlan";
        MTUBytes = "8950";
      };
      vxlanConfig = {
        VNI = 100;
        Local = "10.255.0.1";
        DestinationPort = 4789;
        Independent = true;
        MacLearning = false;
      };
    };
    "20-vxlan200" = {
      netdevConfig = {
        Name = "vxlan200";
        Kind = "vxlan";
        MTUBytes = "8950";
      };
      vxlanConfig = {
        VNI = 200;
        Local = "10.255.0.1";
        DestinationPort = 4789;
        Independent = true;
        MacLearning = false;
      };
    };
    "20-vxlan300" = {
      netdevConfig = {
        Name = "vxlan300";
        Kind = "vxlan";
        MTUBytes = "8950";
      };
      vxlanConfig = {
        VNI = 300;
        Local = "10.255.0.1";
        DestinationPort = 4789;
        Independent = true;
        MacLearning = false;
      };
    };
    # L3 VXLAN netdevs for inter-subnet routing (Type-5 routes)
    "25-vxlan1000" = {
      netdevConfig = {
        Name = "vxlan1000";
        Kind = "vxlan";
        MTUBytes = "8950";
      };
      vxlanConfig = {
        VNI = 1000;
        Local = "10.255.0.1";
        DestinationPort = 4789;
        Independent = true;
        MacLearning = false;
      };
    };
    "25-vxlan2000" = {
      netdevConfig = {
        Name = "vxlan2000";
        Kind = "vxlan";
        MTUBytes = "8950";
      };
      vxlanConfig = {
        VNI = 2000;
        Local = "10.255.0.1";
        DestinationPort = 4789;
        Independent = true;
        MacLearning = false;
      };
    };
    "25-vxlan3000" = {
      netdevConfig = {
        Name = "vxlan3000";
        Kind = "vxlan";
        MTUBytes = "8950";
      };
      vxlanConfig = {
        VNI = 3000;
        Local = "10.255.0.1";
        DestinationPort = 4789;
        Independent = true;
        MacLearning = false;
      };
    };
  };

  # Network configs for VRFs, Bridges, and VXLANs
  systemd.network.networks = {
    "10-vrf-cell1" = {
      matchConfig.Name = "vrf-cell1";
      networkConfig = {
        LinkLocalAddressing = "no";
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
        KeepConfiguration = "no";
      };
      linkConfig.RequiredForOnline = "no";
    };
    "10-vrf-cell2" = {
      matchConfig.Name = "vrf-cell2";
      networkConfig = {
        LinkLocalAddressing = "no";
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
        KeepConfiguration = "no";
      };
      linkConfig.RequiredForOnline = "no";
    };
    "10-vrf-cell3" = {
      matchConfig.Name = "vrf-cell3";
      networkConfig = {
        LinkLocalAddressing = "no";
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
        KeepConfiguration = "no";
      };
      linkConfig.RequiredForOnline = "no";
    };
    # Bridge configs - IP on bridge, in VRF
    "15-br-cell1" = {
      matchConfig.Name = "br-cell1";
      networkConfig = {
        VRF = "vrf-cell1";
        LinkLocalAddressing = "no";
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
      };
      address = [ "10.1.0.1/22" ];
      linkConfig.RequiredForOnline = "no";
    };
    "15-br-cell2" = {
      matchConfig.Name = "br-cell2";
      networkConfig = {
        VRF = "vrf-cell2";
        LinkLocalAddressing = "no";
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
      };
      address = [ "10.2.0.1/22" ];
      linkConfig.RequiredForOnline = "no";
    };
    "15-br-cell3" = {
      matchConfig.Name = "br-cell3";
      networkConfig = {
        VRF = "vrf-cell3";
        LinkLocalAddressing = "no";
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
      };
      address = [ "10.3.0.1/22" ];
      linkConfig.RequiredForOnline = "no";
    };
    # L2 VXLAN configs - enslaved to bridge for VM traffic
    "20-vxlan100" = {
      matchConfig.Name = "vxlan100";
      networkConfig = {
        Bridge = "br-cell1";
        LinkLocalAddressing = "no";
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
      };
      bridgeConfig.Learning = false;
      linkConfig.RequiredForOnline = "no";
    };
    "20-vxlan200" = {
      matchConfig.Name = "vxlan200";
      networkConfig = {
        Bridge = "br-cell2";
        LinkLocalAddressing = "no";
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
      };
      bridgeConfig.Learning = false;
      linkConfig.RequiredForOnline = "no";
    };
    "20-vxlan300" = {
      matchConfig.Name = "vxlan300";
      networkConfig = {
        Bridge = "br-cell3";
        LinkLocalAddressing = "no";
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
      };
      bridgeConfig.Learning = false;
      linkConfig.RequiredForOnline = "no";
    };
    # L3 VXLAN configs - directly in VRF for inter-subnet routing
    "25-vxlan1000" = {
      matchConfig.Name = "vxlan1000";
      networkConfig = {
        VRF = "vrf-cell1";
        LinkLocalAddressing = "no";
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
      };
      linkConfig.RequiredForOnline = "no";
    };
    "25-vxlan2000" = {
      matchConfig.Name = "vxlan2000";
      networkConfig = {
        VRF = "vrf-cell2";
        LinkLocalAddressing = "no";
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
      };
      linkConfig.RequiredForOnline = "no";
    };
    "25-vxlan3000" = {
      matchConfig.Name = "vxlan3000";
      networkConfig = {
        VRF = "vrf-cell3";
        LinkLocalAddressing = "no";
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
      };
      linkConfig.RequiredForOnline = "no";
    };
  };

  # TODO Setup nftables and all that
  # https://francis.begyn.be/blog/nixos-home-router

  # # Set your time zone.
  time.timeZone = "UTC";

  environment.systemPackages = with pkgs; [
    frr
    ppp # TODO Would I need this if I made this my main router?
    ethtool
    tcpdump
    conntrack-tools
    nerdctl
  ];

  # Containerd for running Envoy as a container
  virtualisation.containerd.enable = true;

  # Envoy config file for k8s API server load balancing
  environment.etc."envoy/envoy.yaml".text = ''
    static_resources:
      listeners:
        - name: kube_apiserver
          address:
            socket_address:
              address: 10.0.2.10
              port_value: 6443
          filter_chains:
            - filters:
                - name: envoy.filters.network.tcp_proxy
                  typed_config:
                    "@type": type.googleapis.com/envoy.extensions.filters.network.tcp_proxy.v3.TcpProxy
                    stat_prefix: kube_apiserver
                    cluster: kube_apiserver_cluster
      clusters:
        - name: kube_apiserver_cluster
          connect_timeout: 5s
          type: STATIC
          lb_policy: ROUND_ROBIN
          health_checks:
            - timeout: 2s
              interval: 5s
              healthy_threshold: 2
              unhealthy_threshold: 3
              tcp_health_check: {}
          load_assignment:
            cluster_name: kube_apiserver_cluster
            endpoints:
              - lb_endpoints:
                  - endpoint:
                      address:
                        socket_address:
                          address: 10.0.2.11
                          port_value: 6443
                  - endpoint:
                      address:
                        socket_address:
                          address: 10.0.2.12
                          port_value: 6443
                  - endpoint:
                      address:
                        socket_address:
                          address: 10.0.2.13
                          port_value: 6443
  '';

  # Systemd service to run Envoy container with host networking
  systemd.services.envoy = {
    description = "Envoy Proxy (containerized)";
    after = [
      "network.target"
      "containerd.service"
    ];
    requires = [ "containerd.service" ];
    wantedBy = [ "multi-user.target" ];
    restartTriggers = [ config.environment.etc."envoy/envoy.yaml".source ];

    serviceConfig = {
      ExecStartPre = "${pkgs.nerdctl}/bin/nerdctl pull envoyproxy/envoy:v1.31-latest";
      ExecStart = ''
        ${pkgs.nerdctl}/bin/nerdctl run --rm --name envoy \
          --network host \
          -v /etc/envoy/envoy.yaml:/etc/envoy/envoy.yaml:ro \
          envoyproxy/envoy:v1.31-latest \
          -c /etc/envoy/envoy.yaml
      '';
      ExecStop = "${pkgs.nerdctl}/bin/nerdctl stop envoy";
      Restart = "always";
      RestartSec = "5s";
    };
  };

  networking.firewall.enable = false;
  networking.wireguard.enable = true;

  services.frr = {
    config = frrConfig;
    bgpd.enable = true;
    vrrpd.enable = true;
    bfdd.enable = true;
  };

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
    };
  };

  # DNS forwarder for cell networks
  #
  # Same VRF socket binding issue as Kea - need separate instances per VRF.
  # TODO: Implement a proper VRF-aware UDP proxy to reduce resource usage.
  # See: https://docs.kernel.org/networking/vrf.html
  #
  # Default VRF Unbound serves the underlay network (10.0.2.0/24) and localhost.
  # Per-VRF Unbound instances serve the cell networks.
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [
          "127.0.0.1"
          "10.0.2.1"
        ];
        access-control = [
          "127.0.0.0/8 allow"
          "10.0.2.0/24 allow"
        ];
        do-not-query-localhost = false;
      };
      forward-zone = [
        {
          name = ".";
          forward-addr = "192.168.15.1";
        }
      ];
    };
  };

  # Generate Unbound config files for each cell
  environment.etc."unbound/unbound-cell1.conf".text = ''
    server:
      interface: 10.1.0.1
      access-control: 10.1.0.0/22 allow
      access-control: 127.0.0.0/8 allow
      do-not-query-localhost: no
      chroot: ""
      logfile: ""
      username: ""
    forward-zone:
      name: "."
      forward-addr: 192.168.15.1
  '';

  environment.etc."unbound/unbound-cell2.conf".text = ''
    server:
      interface: 10.2.0.1
      access-control: 10.2.0.0/22 allow
      access-control: 127.0.0.0/8 allow
      do-not-query-localhost: no
      chroot: ""
      logfile: ""
      username: ""
    forward-zone:
      name: "."
      forward-addr: 192.168.15.1
  '';

  environment.etc."unbound/unbound-cell3.conf".text = ''
    server:
      interface: 10.3.0.1
      access-control: 10.3.0.0/22 allow
      access-control: 127.0.0.0/8 allow
      do-not-query-localhost: no
      chroot: ""
      logfile: ""
      username: ""
    forward-zone:
      name: "."
      forward-addr: 192.168.15.1
  '';

  # Systemd services running Unbound in each VRF context
  systemd.services.unbound-cell1 = {
    description = "Unbound DNS Server for Cell1 (VRF)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.iproute2}/bin/ip vrf exec vrf-cell1 ${pkgs.unbound}/bin/unbound -d -c /etc/unbound/unbound-cell1.conf";
      Restart = "on-failure";
    };
  };

  systemd.services.unbound-cell2 = {
    description = "Unbound DNS Server for Cell2 (VRF)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.iproute2}/bin/ip vrf exec vrf-cell2 ${pkgs.unbound}/bin/unbound -d -c /etc/unbound/unbound-cell2.conf";
      Restart = "on-failure";
    };
  };

  systemd.services.unbound-cell3 = {
    description = "Unbound DNS Server for Cell3 (VRF)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.iproute2}/bin/ip vrf exec vrf-cell3 ${pkgs.unbound}/bin/unbound -d -c /etc/unbound/unbound-cell3.conf";
      Restart = "on-failure";
    };
  };

  # Kea DHCP server for cell networks (KubeVirt VMs)
  #
  # Why separate instances per VRF:
  # Each br-cell* bridge is enslaved to a VRF (vrf-cell1, vrf-cell2, vrf-cell3).
  # IP addresses on VRF interfaces are only visible within that VRF's routing domain.
  # A process in the default VRF cannot bind to VRF addresses - the kernel returns
  # "Cannot assign requested address" because the IP isn't local to that context.
  #
  # Solution: Run each Kea instance with `ip vrf exec <vrf>` which uses a cgroup BPF
  # hook to set SO_BINDTODEVICE on all sockets, making VRF addresses bindable.
  # Since a process can only be in one VRF at a time, we need separate instances.
  #
  # See: https://docs.kernel.org/networking/vrf.html
  #      https://man7.org/linux/man-pages/man8/ip-vrf.8.html

  # Disable the default Kea instance
  services.kea.dhcp4.enable = false;

  # Generate Kea config files for each cell
  environment.etc."kea/kea-dhcp4-cell1.conf".text = builtins.toJSON {
    Dhcp4 = {
      valid-lifetime = 3600;
      renew-timer = 1800;
      rebind-timer = 2700;
      lease-database = {
        type = "memfile";
        persist = true;
        name = "/var/lib/kea/dhcp4-cell1.leases";
      };
      interfaces-config = {
        interfaces = [ "br-cell1" ];
        dhcp-socket-type = "raw";
      };
      subnet4 = [
        {
          id = 1;
          subnet = "10.1.0.0/22";
          pools = [ { pool = "10.1.1.0 - 10.1.3.254"; } ];
          option-data = [
            {
              name = "routers";
              data = "10.1.0.1";
            }
            {
              name = "domain-name-servers";
              data = "10.1.0.1";
            }
          ];
        }
      ];
    };
  };

  environment.etc."kea/kea-dhcp4-cell2.conf".text = builtins.toJSON {
    Dhcp4 = {
      valid-lifetime = 3600;
      renew-timer = 1800;
      rebind-timer = 2700;
      lease-database = {
        type = "memfile";
        persist = true;
        name = "/var/lib/kea/dhcp4-cell2.leases";
      };
      interfaces-config = {
        interfaces = [ "br-cell2" ];
        dhcp-socket-type = "raw";
      };
      subnet4 = [
        {
          id = 2;
          subnet = "10.2.0.0/22";
          pools = [ { pool = "10.2.1.0 - 10.2.3.254"; } ];
          option-data = [
            {
              name = "routers";
              data = "10.2.0.1";
            }
            {
              name = "domain-name-servers";
              data = "10.2.0.1";
            }
          ];
        }
      ];
    };
  };

  environment.etc."kea/kea-dhcp4-cell3.conf".text = builtins.toJSON {
    Dhcp4 = {
      valid-lifetime = 3600;
      renew-timer = 1800;
      rebind-timer = 2700;
      lease-database = {
        type = "memfile";
        persist = true;
        name = "/var/lib/kea/dhcp4-cell3.leases";
      };
      interfaces-config = {
        interfaces = [ "br-cell3" ];
        dhcp-socket-type = "raw";
      };
      subnet4 = [
        {
          id = 3;
          subnet = "10.3.0.0/22";
          pools = [ { pool = "10.3.1.0 - 10.3.3.254"; } ];
          option-data = [
            {
              name = "routers";
              data = "10.3.0.1";
            }
            {
              name = "domain-name-servers";
              data = "10.3.0.1";
            }
          ];
        }
      ];
    };
  };

  # Systemd services running Kea in each VRF context
  systemd.services.kea-dhcp4-cell1 = {
    description = "Kea DHCP4 Server for Cell1 (VRF)";
    after = [
      "network.target"
      "sys-subsystem-net-devices-br\\x2dcell1.device"
    ];
    wants = [ "sys-subsystem-net-devices-br\\x2dcell1.device" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.iproute2}/bin/ip vrf exec vrf-cell1 ${pkgs.kea}/bin/kea-dhcp4 -c /etc/kea/kea-dhcp4-cell1.conf";
      Restart = "on-failure";
      StateDirectory = "kea";
    };
  };

  systemd.services.kea-dhcp4-cell2 = {
    description = "Kea DHCP4 Server for Cell2 (VRF)";
    after = [
      "network.target"
      "sys-subsystem-net-devices-br\\x2dcell2.device"
    ];
    wants = [ "sys-subsystem-net-devices-br\\x2dcell2.device" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.iproute2}/bin/ip vrf exec vrf-cell2 ${pkgs.kea}/bin/kea-dhcp4 -c /etc/kea/kea-dhcp4-cell2.conf";
      Restart = "on-failure";
      StateDirectory = "kea";
    };
  };

  systemd.services.kea-dhcp4-cell3 = {
    description = "Kea DHCP4 Server for Cell3 (VRF)";
    after = [
      "network.target"
      "sys-subsystem-net-devices-br\\x2dcell3.device"
    ];
    wants = [ "sys-subsystem-net-devices-br\\x2dcell3.device" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.iproute2}/bin/ip vrf exec vrf-cell3 ${pkgs.kea}/bin/kea-dhcp4 -c /etc/kea/kea-dhcp4-cell3.conf";
      Restart = "on-failure";
      StateDirectory = "kea";
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
