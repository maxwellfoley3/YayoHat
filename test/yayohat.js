const BigNumber = web3.utils.BN;

const YayoSwap = artifacts.require("YayoSwap");
const HatToken = artifacts.require("HatToken");
const HatNFT = artifacts.require("HatNFT");
const MockYayoToken = artifacts.require("MockYayoToken");
const YayoSwapRouter = artifacts.require("YayoSwapRouter");

const NUMBER_OF_HATS = 500;
const DECIMALS = 18;

function toBaseUnits(num) {
  return new BigNumber(num).mul((new BigNumber(10)).pow(new BigNumber(DECIMALS)));
}
contract("YayoSwap", accounts => {
  it("should be able to buy hat", async () => {
    const yayoSwap = await YayoSwap.deployed();
    const hatToken = await HatToken.deployed();
    const hatNFT = await HatNFT.deployed();
    const yayoToken = await MockYayoToken.deployed();
    const yayoSwapRouter = await YayoSwapRouter.deployed();

    // initialize YayoSwap
    await yayoSwap.initialize(yayoToken.address, hatToken.address, toBaseUnits(620));
    
    // transfer hat tokens
    await hatToken.transfer(yayoSwap.address, toBaseUnits(NUMBER_OF_HATS));
    await yayoSwap.sync();

    const INITIAL_PRICE = 25;
    // give user money
    await yayoToken.transfer(accounts[1], toBaseUnits(INITIAL_PRICE));

    // purchase a hat token
    await yayoToken.approve(yayoSwapRouter.address, toBaseUnits(INITIAL_PRICE), { from: accounts[1] });
    await yayoSwapRouter.swapYayoForExactHat(
      toBaseUnits(1), toBaseUnits(INITIAL_PRICE), accounts[1], Date.now() + 100000, { from: accounts[1] }
    );

    // purchase NFT with hat token
    await hatToken.approve(hatNFT.address, toBaseUnits(1), { from: accounts[1] });
    await hatNFT.buyHat({ from: accounts[1] });
  })
})
