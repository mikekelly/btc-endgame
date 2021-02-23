#!/bin/bash
set -e

git checkout docker-compose.yml
docker-compose down
rm -rf *-node-data
