const fcc = artifacts.require("FantasyCricketCoin");
const match = artifacts.require("MatchFCC");

module.exports = function(deployer) {
  deployer.deploy(fcc);
  deployer.deploy(match);
};
