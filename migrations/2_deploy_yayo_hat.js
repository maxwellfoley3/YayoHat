var YayoSwap = artifacts.require("YayoSwap");
var HatToken = artifacts.require("HatToken");
var HatNFT = artifacts.require("HatNFT");
var MockYayoToken = artifacts.require("MockYayoToken");
var YayoSwapRouter = artifacts.require("YayoSwapRouter");

const NUMBER_OF_HATS = 500;

module.exports = async function(deployer, network, accounts) {
  await deployer.deploy(YayoSwap, accounts[0]);
  await deployer.deploy(HatToken, NUMBER_OF_HATS);
  await deployer.deploy(HatNFT, HatToken.address, NUMBER_OF_HATS);
  await deployer.deploy(MockYayoToken, 10000000)
  await deployer.deploy(YayoSwapRouter, YayoSwap.address, MockYayoToken.address, HatToken.address)
};
