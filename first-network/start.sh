#!/bin/bash

export CHANNEL_NAME=mychannel

# Stop all client, peer and order containers
docker-compose -f docker-compose-cli.yaml down

# Start all client, peer and order containers
docker-compose -f docker-compose-cli.yaml up -d
if [ "$?" -ne 0 ]; then
  echo "Failed to start all client, peer and order containers..."
  exit 1
fi

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
# export FABRIC_START_TIMEOUT=5
# sleep ${FABRIC_START_TIMEOUT}

# Create the channel
docker exec -it cli peer channel create -o orderer.kaopiz.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/kaopiz.com/orderers/orderer.kaopiz.com/msp/tlscacerts/tlsca.kaopiz.com-cert.pem
if [ "$?" -ne 0 ]; then
  echo "Failed to create channel..."
  exit 1
fi

# Join peer0.org1.kaopiz.com to the channel.
docker exec -it cli peer channel join -b $CHANNEL_NAME.block
if [ "$?" -ne 0 ]; then
  echo "Failed to join peer0.org1.kaopiz.com to the channel..."
  exit 1
fi

# Join peer0.org2.kaopiz.com to the channel.
docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.kaopiz.com/users/Admin@org2.kaopiz.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.kaopiz.com:7051" -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.kaopiz.com/peers/peer0.org2.kaopiz.com/tls/ca.crt" -it cli peer channel join -b $CHANNEL_NAME.block
if [ "$?" -ne 0 ]; then
  echo "Failed to join peer0.org2.kaopiz.com to the channel..."
  exit 1
fi

# Join peer0.org3.kaopiz.com to the channel.
docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.kaopiz.com/users/Admin@org3.kaopiz.com/msp" -e "CORE_PEER_ADDRESS=peer0.org3.kaopiz.com:7051" -e "CORE_PEER_LOCALMSPID=Org3MSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.kaopiz.com/peers/peer0.org3.kaopiz.com/tls/ca.crt" -it cli peer channel join -b $CHANNEL_NAME.block
if [ "$?" -ne 0 ]; then
  echo "Failed to join peer0.org3.kaopiz.com to the channel..."
  exit 1
fi

# # Update anchor peers, peers have anchored by generate.sh yet!
# docker exec -it cli peer channel update -o orderer.kaopiz.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/kaopiz.com/orderers/orderer.kaopiz.com/msp/tlscacerts/tlsca.example.com-cert.pem
# docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.kaopiz.com/users/Admin@org2.kaopiz.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.kaopiz.com:7051" -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.kaopiz.com/peers/peer0.org2.kaopiz.com/tls/ca.crt" -it cli peer channel update -o orderer.kaopiz.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org2MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/kaopiz.com/orderers/orderer.kaopiz.com/msp/tlscacerts/tlsca.example.com-cert.pem
# docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.kaopiz.com/users/Admin@org3.kaopiz.com/msp" -e "CORE_PEER_ADDRESS=peer0.org3.kaopiz.com:7051" -e "CORE_PEER_LOCALMSPID=Org3MSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.kaopiz.com/peers/peer0.org3.kaopiz.com/tls/ca.crt" -it cli peer channel update -o orderer.kaopiz.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org3MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/kaopiz.com/orderers/orderer.kaopiz.com/msp/tlscacerts/tlsca.example.com-cert.pem

# Install chaincode on peer
docker exec -it cli peer chaincode install -n mycc -v 1.0 -p github.com/chaincode/example/
# # Can install chaincode from other peers as bellow
# docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.kaopiz.com/users/Admin@org2.kaopiz.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.kaopiz.com:7051" -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.kaopiz.com/peers/peer0.org2.kaopiz.com/tls/ca.crt" -it cli peer chaincode install -n mycc -v 1.0 -p github.com/chaincode/example/
# docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.kaopiz.com/users/Admin@org3.kaopiz.com/msp" -e "CORE_PEER_ADDRESS=peer0.org3.kaopiz.com:7051" -e "CORE_PEER_LOCALMSPID=Org3MSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.kaopiz.com/peers/peer0.org3.kaopiz.com/tls/ca.crt" -it cli peer chaincode install -n mycc -v 1.0 -p github.com/chaincode/example/
if [ "$?" -ne 0 ]; then
  echo "Failed to install chaincode on peer..."
  exit 1
fi

# Instantiate chaincode on channel
docker exec -it cli peer chaincode instantiate -o orderer.kaopiz.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/kaopiz.com/orderers/orderer.kaopiz.com/msp/tlscacerts/tlsca.kaopiz.com-cert.pem -C $CHANNEL_NAME -n mycc -v 1.0 -c '{"Args":["a", "10"]}' -P "OR ('Org1MSP.member','Org2MSP.member','Org3MSP.member')"
if [ "$?" -ne 0 ]; then
  echo "Failed to instantiate chaincode on channel..."
  exit 1
fi

# Other commands (for using, don't importing in script)
# # Check certificate
# openssl x509 -in /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/kaopiz.com/orderers/orderer.kaopiz.com/msp/tlscacerts/tlsca.kaopiz.com-cert.pem -text