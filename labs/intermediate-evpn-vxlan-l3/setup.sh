#!/bin/bash
CLIENT_CFG_DIR=./clients
CLAB=clab-intermediate-evpn-vxlan-l3

configure_SWITCH() {
  docker cp $1/$1.sh $CLAB-$1:/tmp/
  docker exec $CLAB-$1 bash /tmp/$1.sh 2>/dev/null
}

configure_CLIENT() {
  docker cp $CLIENT_CFG_DIR/$1.sh $CLAB-$1:/tmp/
  docker exec $CLAB-$1 bash /tmp/$1.sh 2>/dev/null
}

echo
SWITCHES=("spine01" "spine02" "leaf01" "leaf02" "leaf03")
CLIENTS=("client1" "client2" "client3")

for VARIANT in ${SWITCHES[@]}; do
  ( configure_SWITCH $VARIANT ) &
  REF=$!
  echo "[$REF] Configuring $VARIANT..."
done

for VARIANT in ${CLIENTS[@]}; do
  ( configure_CLIENT $VARIANT ) &
  REF=$!
  echo "[$REF] Configuring $VARIANT..."
done