#!/bin/bash
set -e

echo "Bringing up everything apart from the miners..."
docker-compose up -d blue-node jack-node jill-node
docker-compose up -d explorer snitch runner

echo "Waiting 20s for the runner to create the wallets"
sleep 20

echo "Bring up the blue team miner to confirm the seed transactions for Jack and Jill"
docker-compose up -d blue-miner

echo "Wait 30s for blue team miner to confirm a few blocks"
sleep 30

echo "Bring up the red team stuff and anything else that's left"
docker-compose up -d
