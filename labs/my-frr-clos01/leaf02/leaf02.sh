#!/bin/bash
echo "8021q" >> /etc/modules

cat > /etc/network/interfaces << EOF
auto lo1
iface lo1 inet manual
    pre-up ip link add name lo1 type dummy
    up ip link set dev lo1 up

auto eth3.10
iface eth3.10 inet manual
    pre-up ip link add name eth3.10 link eth3 type vlan id 10
    up ip link set dev eth3.10 up

auto vxlan0
iface vxlan0 inet manual
    pre-up ip link add name vxlan0 type vxlan id 10000 local 172.30.1.4 dstport 4789 nolearning
    up ip link set dev vxlan0 up

auto br10
iface br10 inet manual
    pre-up ip link add name br10 type bridge
    post-up ip link set dev vxlan0 master br10
    post-up ip link set dev eth3.10 master br10
    up ip link set dev br10 up
    bridge_stp off

EOF

ifup lo1
ifup eth3.10
ifup vxlan0
ifup br10

# hwaddress ether 02:01:02:03:04:05