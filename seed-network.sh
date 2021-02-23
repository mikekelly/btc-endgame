#!/bin/bash
set -e

./cleandown.sh

docker-compose up -d blue-node red-node

# TODO: a proper healthcheck loop using docker-cli
echo "Waiting 30 sec for nodes to come online"
sleep 30

echo "Creating blue wallet..."
docker-compose exec blue-node bitcoin-cli createwallet bluewallet
echo "Creating red wallet..."
docker-compose exec red-node bitcoin-cli createwallet redwallet

echo "Creating blue team coinbase address..."
BLUE_COINBASE_ADDR=$(docker-compose exec blue-node bitcoin-cli getnewaddress)
echo "${BLUE_COINBASE_ADDR}"
echo "Creating red team coinbase address..."
RED_COINBASE_ADDR=$(docker-compose exec red-node bitcoin-cli getnewaddress)
echo "${RED_COINBASE_ADDR}"

echo "Configuring coinbase addresses in docker-compose.yml..."
sed -i -e "s/REPLACE_WITH_BLUE_COINBASE_ADDR/${BLUE_COINBASE_ADDR}/g" docker-compose.yml
sed -i -e "s/REPLACE_WITH_RED_COINBASE_ADDR/${RED_COINBASE_ADDR}/g" docker-compose.yml

echo "Creating initial block..."
docker-compose exec blue-node bitcoin-cli -generate
