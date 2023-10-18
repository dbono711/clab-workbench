# intermediate-evpn-vxlan-l3
Intermediate EVPN-VXLAN 3-stage IP CLOS fabric using [FRR](https://docs.frrouting.org/en/latest/evpn.html) to facilitate Layer 2 connectivity between clients in VLAN10 (client1/client2) over VNI 110, as well as Layer 3 connectivity to/from those clients in VLAN20 (client3) over VNI 120. Assymetric IRB will be utilized for inter-VNI routing.

## Topology
```mermaid
```

## Resources

### IP Assignments
**NOTE**: The Overlay/VTEP assignments for spine01/spine02/spine03 are not actually implemented, or even required, since our VTEP's in this lab are on leaf01/leaf02/leaf03. The assignments are therefore just for consistency purposes

| Scope              | Network       | Sub-Network    | Assignment     | Name            |
| ------------------ | ------------- | -------------  | -------------  | -------         |
| Management         | 172.28.1.0/24 |                | 172.28.1.2/24  | spine01         |
| Management         | 172.28.1.0/24 |                | 172.28.1.3/24  | spine02         |
| Management         | 172.28.1.0/24 |                | 172.28.1.4/24  | leaf01          |
| Management         | 172.28.1.0/24 |                | 172.28.1.5/24  | leaf02          |
| Management         | 172.28.1.0/24 |                | 172.28.1.6/24  | leaf03          |
| Router ID (lo)     | 172.29.1.0/24 |                | 172.19.1.1/24  | spine01         |
| Router ID (lo)     | 172.29.1.0/24 |                | 172.19.1.2/24  | spine02         |
| Router ID (lo)     | 172.29.1.0/24 |                | 172.19.1.3/24  | leaf01          |
| Router ID (lo)     | 172.29.1.0/24 |                | 172.19.1.4/24  | leaf02          |
| Router ID (lo)     | 172.29.1.0/24 |                | 172.19.1.5/24  | leaf03          |
| Overlay/VTEP (lo1) | 172.30.1.0/24 |                | 172.30.1.1/24  | spine01         |
| Overlay/VTEP (lo1) | 172.30.1.0/24 |                | 172.30.1.2/24  | spine02         |
| Overlay/VTEP (lo1) | 172.30.1.0/24 |                | 172.30.1.3/24  | leaf01          |
| Overlay/VTEP (lo1) | 172.30.1.0/24 |                | 172.30.1.4/24  | leaf02          |
| Overlay/VTEP (lo1) | 172.30.1.0/24 |                | 172.30.1.5/24  | leaf03          |
| P2P Links          | 172.31.1.0/24 | 172.31.1.0/31  | 172.31.1.0/31  | spine01::leaf01 |
| P2P Links          | 172.31.1.0/24 | 172.31.1.0/31  | 172.31.1.1/31  | leaf01::spine01 |
| P2P Links          | 172.31.1.0/24 | 172.31.1.2/31  | 172.31.1.2/31  | spine01::leaf02 |
| P2P Links          | 172.31.1.0/24 | 172.31.1.2/31  | 172.31.1.3/31  | leaf02::spine01 |
| P2P Links          | 172.31.1.0/24 | 172.31.1.4/31  | 172.31.1.4/31  | spine02::leaf01 |
| P2P Links          | 172.31.1.0/24 | 172.31.1.4/31  | 172.31.1.5/31  | leaf01::spine02 |
| P2P Links          | 172.31.1.0/24 | 172.31.1.6/31  | 172.31.1.6/31  | spine02::leaf02 |
| P2P Links          | 172.31.1.0/24 | 172.31.1.6/31  | 172.31.1.7/31  | leaf02::spine02 |
| P2P Links          | 172.31.1.0/24 | 172.31.1.8/31  | 172.31.1.8/31  | spine01::leaf03 |
| P2P Links          | 172.31.1.0/24 | 172.31.1.8/31  | 172.31.1.9/31  | leaf03::spine01 |
| P2P Links          | 172.31.1.0/24 | 172.31.1.10/31 | 172.31.1.10/31 | spine02::leaf03 |
| P2P Links          | 172.31.1.0/24 | 172.31.1.10/31 | 172.31.1.11/31 | leaf03::spine02 |

### ASN Assignments
| ASN   | Device  |
| ----- | ------- |
| 65500 | spine01 |
| 65501 | spine02 |
| 65502 | leaf01  |
| 65503 | leaf02  |
| 65504 | leaf03  |

### VXLAN Segments
| vni | name  | network      | leaf   | host    | host ip   | vlan |
| --- | ----  | ------------ | ------ | ------- | --------- | ---- |
| 110 | RED   | 10.10.1.0/24 | leaf01 | client1 | 10.10.1.1 | 10   |
| 110 | RED   | 10.10.1.0/24 | leaf02 | client2 | 10.10.1.2 | 10   |
| 120 | BLUE  | 10.20.1.0/24 | leaf03 | client3 | 10.20.1.1 | 20   |

## Deployment
**NOTE**: Assumes Visual Studio Code has properly deployed the development container per the top-level [README.md](../../README.md)

Access the development container
```
docker exec -it clab-dev bash
```

Change into the lab directory
```
cd workspaces/clab-workbench/labs/intermediate-evpn-vxlan-l3/
```

Execute the [deployment script](#deployment-script) to start the lab
```
bash deploy.sh
```

Stop the lab, tear down the CONTAINERlab containers
```
bash destroy.sh
```

## Deployment Script
The ```deploy.sh``` script performs the following functions

* Creates the [CONTAINERlab network](https://containerlab.dev/manual/topo-def-file/) based on the [setup.yml](setup.yml) topology definition
* Executes the [setup.sh](setup.sh) configuration script
  * Loops through each client to execute the respective script within the [clients](clients) folder
    * The script configures the Ethernet VLAN interface connected to the leaf
  * Loops through each switch to execute the respective script within the ```spine01|02 leaf01|02``` folder
    * The script configures the Linux-level Ethernet, Dummy, VXLAN, and Bridge interfaces; leaving the IP/Network-level configuration to FRR

## Validation
To validate that everything is working as expected:

1. Execute a PING from ```client1``` to ```client2```

Access the ```client1``` container _(assumes you are still in the development container per the [deployment](#deployment) instructions)_
```
docker exec -it clab-intermediate-evpn-vxlan-l2-client1 bash
```

PING the ```client2``` host IP
```
ping -c 5 10.10.1.2
```

2. Execute a PING from ````client1`` to ```client3```
