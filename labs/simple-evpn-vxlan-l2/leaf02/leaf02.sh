#!/bin/bash
echo "8021q" >> /etc/modules

cat > /etc/network/interfaces << EOF
##################
## create VTEP interface
##################
auto lo1
iface lo1 inet manual
    pre-up ip link add name lo1 type dummy
    up ip link set dev lo1 up

##################
## create vlan 10 subinterface of eth3 for l2vni 110
##################
auto eth3.10
iface eth3.10 inet manual
    pre-up ip link add name eth3.10 link eth3 type vlan id 10
    up ip link set dev eth3.10 up

###############
## create l2vni 110
###############
auto vxlan110
iface vxlan110 inet manual
    pre-up ip link add name vxlan110 type vxlan id 110 local 172.30.1.4 dstport 4789 nolearning
    up ip link set dev vxlan110 up

###############
## create SVI as type bridge and enslave interfaces
###############
auto br10
iface br10 inet manual
    pre-up ip link add name br10 type bridge
    post-up ip link set dev vxlan110 master br10
    post-up ip link set dev eth3.10 master br10
    up ip link set dev br10 up
    bridge_stp off

EOF

ifup lo1
ifup eth3.10
ifup vxlan110
ifup br10
