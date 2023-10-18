#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

echo -n "Deploying ContainerLAB topology..."
sudo clab deploy --topo setup.yml > log.txt 2>&1
sleep 5
echo "[OK]"

echo -n "Applying Router & Client configuration..."
./setup.sh >> log.txt 2>&1
sleep 5
echo "[OK]"

echo -n "Validating connectivity..."
python validate.py >> log.txt 2>&1
echo "[OK]"

echo "Complete! Check 'log.txt' for detailed ouput"
