#!/bin/bash
CLIENT_CFG_DIR=./clients

configure_SWITCH() {
  docker cp $1/$1.sh clab-my-frr-clos01-$1:/tmp/
  docker exec clab-my-frr-clos01-$1 bash /tmp/$1.sh 2>/dev/null
}

configure_CLIENT() {
  docker cp $CLIENT_CFG_DIR/$1.sh clab-my-frr-clos01-$1:/tmp/
  docker exec clab-my-frr-clos01-$1 bash /tmp/$1.sh 2>/dev/null
}

echo
SWITCHES=("spine01" "spine02" "leaf01" "leaf02")
CLIENTS=("client1" "client2")

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