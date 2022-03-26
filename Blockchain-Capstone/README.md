# Project Basic Info
## Version
* Truffle v5.0.6 (core: 5.0.6)
* Solidity v0.5.2 (solc-js)
* Node v12 (Use v14 at first, however it can not migrate to rinkeby, so I downgrade to v12)
* Web3.js v1.5.3

## How to test the code
```bash
    npm install
    cd eth-contracts
    truffle test
```

## How to deploy to Rinkeby network
```bash
    truffle migrate --network rinkeby
```

## How to create a new Zokrates solution
```bash
    ~/zokrates compute-witness -a {num_1} {num_1 * num_1}
    ~/zokrates generate-proof
```
-> get proof.json and witness file

## Contract Addresses, Contract Abi's, OpenSea MarketPlace Storefront link's.

### Contract Addresses
 1. [Deploying Migrations](https://rinkeby.etherscan.io/address/0x236C3C77363340A5B82c7efc14d377DE107Aa563)
 2. [ERC721MintableComplete](https://rinkeby.etherscan.io/address/0xCD179A8E4bAeE1E889943c3D9886B0f693dA86E0)
 3. [SquareVerifier](https://rinkeby.etherscan.io/address/0x8689A71c097823CE539C36d410abDa21942F270b)
 4. [SolnSquareVerifier](https://rinkeby.etherscan.io/address/0xdf88c136c323d884edc1d47055deaeba59b2c64b)

### Contract ABI's
1. ERC721MintableComplete: [eth-contracts/build/contracts/ERC721MintableComplete.json](eth-contracts/build/contracts/ERC721MintableComplete.json])
2. SquareVerifier: [eth-contracts/build/contracts/SquareVerifier.json](eth-contracts/build/contracts/SquareVerifier.json)
3. SolnSquareVerifier: [eth-contracts/build/contracts/SolnSquareVerifier.json](eth-contracts/build/contracts/SolnSquareVerifier.json)

### OpenSea MarketPlace Storefront link
* Storefront: https://testnets.opensea.io/collection/haohao-udacity-token
* Token1: https://testnets.opensea.io/assets/0xdf88c136c323d884edc1d47055deaeba59b2c64b/1
* Token2: https://testnets.opensea.io/assets/0xdf88c136c323d884edc1d47055deaeba59b2c64b/2

# Project requirements
## ERC721
* Completes the boilerplate ERC721 Mintable Contract in ERC721Mintable.sol - V
* Writes and passes the test cases in TestERC721Mintable.js - V
* Writes and passes the test cases in 'TestSquareVerifier.js' - V
* Writes and passes the test cases in TestSolnSquareVerifier.js - V  
* Notes: SquareVerifier - A Contract to verify tx generate by zokrates
* Notes: SolnSquareVerifier - A Contract to make sure a solution can be added and can mint
## Zokrates
* Completes the Zokrates proof in square.code by adding the variable names in square.code - V
```bash
    zokrates compile -i square.code
    zokrates setup
    zokrates compute-witness -a 337 113569
    zokrates generate-proof
    zokrates export-verifier

 ```
* Completes test contract in SolnSquareVerifier.sol - V
* Writes and passes the test cases in 'TestSolnSquareVerifier.js' - V

## OpenSea Marketplace
* List ERC721/ ZoKrates tokens & complete transactions on market place - V

## Deployment
* Deploys ERC721 contracts with Zokrates integration. - V


# Udacity Blockchain Capstone

The capstone will build upon the knowledge you have gained in the course in order to build a decentralized housing product. 

# Project Resources

* [Remix - Solidity IDE](https://remix.ethereum.org/)
* [Visual Studio Code](https://code.visualstudio.com/)
* [Truffle Framework](https://truffleframework.com/)
* [Ganache - One Click Blockchain](https://truffleframework.com/ganache)
* [Open Zeppelin ](https://openzeppelin.org/)
* [Interactive zero knowledge 3-colorability demonstration](http://web.mit.edu/~ezyang/Public/graph/svg.html)
* [Docker](https://docs.docker.com/install/)
* [ZoKrates](https://github.com/Zokrates/ZoKrates)
