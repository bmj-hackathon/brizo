#!/bin/sh

export CONFIG_FILE=/brizo/config.ini
envsubst < /brizo/config.ini.template > /brizo/config.ini
if [ "${LOCAL_CONTRACTS}" = "true" ]; then
  echo "Waiting for contracts to be generated..."
  while [ ! -f "/usr/local/keeper-contracts/ready" ]; do
    sleep 2
  done
fi

if [ -z "${MARKET_ADDRESS}" ]; then
  market=$(python -c "import sys, json; print(json.load(open('/usr/local/keeper-contracts/OceanMarket.development.json', 'r'))['address'])")
  sed -i -e "/market.address =/c market.address = ${market}" /brizo/config.ini
fi

if [ -z "${AUTH_ADDRESS}" ]; then
  auth=$(python -c "import sys, json; print(json.load(open('/usr/local/keeper-contracts/OceanAuth.development.json', 'r'))['address'])")
  sed -i -e "/auth.address =/c auth.address = ${auth}" /brizo/config.ini
fi

if [ -z "${TOKEN_ADDRESS}" ]; then
  token=$(python -c "import sys, json; print(json.load(open('/usr/local/keeper-contracts/OceanToken.development.json', 'r'))['address'])")
  sed -i -e "/token.address =/c token.address = ${token}" /brizo/config.ini
fi

if [ -z "${DIDREGISTRY_ADDRESS}" ]; then
  did=$(python -c "import sys, json; print(json.load(open('/usr/local/keeper-contracts/DIDRegistry.development.json', 'r'))['address'])")
  sed -i -e "/didregistry.address =/c didregistry.address = ${did}" /brizo/config.ini
fi

gunicorn -b ${BRIZO_URL#*://} -w ${BRIZO_WORKERS} brizo.run:app
tail -f /dev/null