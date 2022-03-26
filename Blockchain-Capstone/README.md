# Project Deliverables
# Project Version Info
* Truffle v5.0.6 (core: 5.0.6)
* Solidity v0.5.2 (solc-js)
* Node v14.17.1
* Web3.js v1.5.3

## How to test the code
```bash
    npm install
    cd eth-contracts
    truffle test
```
## Contract Addresses, Contract Abi's, OpenSea MarketPlace Storefront link's.

# Project requirements
## ERC721
* Completes the boilerplate ERC721 Mintable Contract in ERC721Mintable.sol - V
* Writes and passes the test cases in TestERC721Mintable.js - 
* Writes and passes the test cases in 'TestSquareVerifier.js' - 
* Writes and passes the test cases in TestSolnSquareVerifier.js - 

## Zokrates
* Completes the Zokrates proof in square.code by adding the variable names in square.code - V
```bash
    zokrates compile -i square.code
    zokrates setup
    zokrates compute-witness -a 337 113569
    zokrates generate-proof
    zokrates export-verifier

 ```
* Completes test contract in SolnSquareVerifier.sol - 
* Writes and passes the test cases in 'TestSolnSquareVerifier.js' - 

## OpenSea Marketplace
* List ERC721/ ZoKrates tokens & complete transactions on market place -

## Deployment
* Deploys ERC721 contracts with Zokrates integration.



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
