const verse = artifacts.require("HungerVerse");

module.exports = function(deployer) {
  deployer.deploy(verse);
};
