# Hyperledger-Fabric-Sample
Simple implementation for hyperledger-fabric platform
# Contents
* [Introduction](#intro)
* [Enviroment](#env)
* [Clone repository](#clone)
* [Pull docker images](#pull)
* [Create the Hyperledger Fabric blockchain network](#create)
* [Start network](#start)
* [Execute chaincode](#execute)
* [References](#refer)
# <a name="intro">Introduction</a>
In this article, We'll etablish a development bussiness network based on hyperledger-fabric platform and install simple chaincode to this network.
For more informations about Hyperledger-Fabric, see the [Hyperledger documentation](http://hyperledger-fabric.readthedocs.io/en/latest/)
# <a name="env">Enviroment</a>
* OS: Ubuntu 16.04.4 LTS
* Node.js and npm
* Docker
* Docker compose
* Go language
# <a name="clone">Clone repository</a>
`$ cd $GOPATH/src/github.com/hyperledger`

`~/go/src/github.com/hyperledger$ git clone https://github.com/Tronglx/Hyperledger-Fabric-Sample.git`
# <a name="pull">Pull docker images</a>
We need docker images to start docker container for peer, orderer, client components.

`$ cd $GOPATH/src/github.com/hyperledger/Hyperledger-Fabric-Sample/bin`

`~/go/src/github.com/hyperledger/Hyperledger-Fabric-Sample/bin$ ./get-docker-images.sh`
# <a name="create">Create the Hyperledger Fabric blockchain network</a>
Create two folders: channel-artifacts and  crypto-config. These folders will hold peer, orderer certificates and genesis block of blockchain network.

`~/go/src/github.com/hyperledger/Hyperledger-Fabric-Sample/first-network$ mkdir channel-artifacts`

`~/go/src/github.com/hyperledger/Hyperledger-Fabric-Sample/first-network$ mkdir crypto-config`

All command line need to generate metarial of network be bundled in generate.sh script.

Run script:

`~/go/src/github.com/hyperledger/Hyperledger-Fabric-Sample/first-network$ ./generate.sh`
# <a name="start">Start network</a>
All command line need to start network be bundled in start.sh script.

Run script:

`~/go/src/github.com/hyperledger/Hyperledger-Fabric-Sample/first-network$ ./start.sh`
# <a name="execute">Execute chaincode</a>
## Query chaincode
`~/go/src/github.com/hyperledger/Hyperledger-Fabric-Sample/first-network$ docker exec -it cli peer chaincode query -C mychannel -n mycc -v 1.0 -c '{"Args":["query", "a"]}'`

## Invoke chaincode
`~/go/src/github.com/hyperledger/Hyperledger-Fabric-Sample/first-network$ docker exec -it cli peer chaincode invoke -o orderer.kaopiz.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/kaopiz.com/orderers/orderer.kaopiz.com/msp/tlscacerts/tlsca.kaopiz.com-cert.pem -C mychannel -n mycc -v 1.0 -c '{"Args":["set", "a", "20"]}'`
# <a name="refer">References</a>
[Chaincode tutorial](http://hyperledger-fabric.readthedocs.io/en/release-1.1/chaincode4ade.html)

[Create a Development Business Network](https://github.com/CATechnologies/blockchain-tutorials/wiki/Tutorial:-Hyperledger-Fabric-v1.1-%E2%80%93-Create-a-Development-Business-Network-on-zLinux#retrieve-artifacts-from-hyperledger-fabric-repositories) 
