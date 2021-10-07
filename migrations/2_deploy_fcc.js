const fcc = artifacts.require("FantasyCricketCoin");

module.exports = function(deployer) {
  deployer.deploy(fcc);
};
