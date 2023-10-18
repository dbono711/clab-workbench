#!/bin/bash
echo "8021q" >> /etc/modules

# create VTEP source interface
ip link add name lo1 type dummy
