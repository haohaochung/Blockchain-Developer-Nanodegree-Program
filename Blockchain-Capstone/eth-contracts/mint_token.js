const Web3 = require('web3');
const HDWalletProvider = require('@truffle/hdwallet-provider');
const secret = require('./.secret.json');
const SolnSquareVerifierArtifact = require('./build/contracts/SolnSquareVerifier.json'); //ABI

const provider = new HDWalletProvider(
    secret.walletPrivateKey,
    `https://rinkeby.infura.io/v3/${secret.infuraKey}`
);

const web3 = new Web3(provider);
const soln = new web3.eth.Contract(
    SolnSquareVerifierArtifact.abi,
    '0xdf88c136c323d884edc1d47055deaeba59b2c64b' // Contract address
);

// Mint will be reverted if proof already exist, every solution should be unique
const proof = require('../zokrates/code/square/proof2.json'); 

(async () => {
    console.log(`getting defaultAccount`);
    const accounts = await web3.eth.getAccounts();
    const account = accounts[0];
    console.log(`got account=${account}`);

    try {
        await soln.methods.mint(
            account,
            proof.proof.A,
            proof.proof.A_p,
            proof.proof.B,
            proof.proof.B_p,
            proof.proof.C,
            proof.proof.C_p,
            proof.proof.H,
            proof.proof.K,
            proof.input
        )
        .send({ from: account });
        console.log(`minting token with proof completed`);
    } catch (error) {
        console.error(`mint token with proof error=`, error);
    }
})();
