// migrating the appropriate contracts
var ERC721MintableComplete = artifacts.require('ERC721MintableComplete');
var SquareVerifier = artifacts.require('SquareVerifier');
var SolnSquareVerifier = artifacts.require('SolnSquareVerifier');

module.exports = function (deployer) {
  deployer.deploy(ERC721MintableComplete);
  deployer.deploy(SquareVerifier).then(() => {
    deployer.deploy(SolnSquareVerifier, SquareVerifier.address);
  });
};
