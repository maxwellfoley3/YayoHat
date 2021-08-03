pragma solidity =0.5.16;

import "./ERC721.sol";
import "./ERC20Burnable.sol";

contract HatNFT is ERC721 {
  address token;
  uint numberToMint;
  uint currentIdForSale;


  constructor(address _token, uint _numberToMint) ERC721("Yayo Hat", "YAYOHAT") public {
    token = _token;
    numberToMint = _numberToMint;
    currentIdForSale = 0;
  }

  function buyHat() public {
    require(currentIdForSale < numberToMint, "Sold out!");
    ERC20Burnable(token).burnFrom(msg.sender, 10 ** uint(ERC20Burnable(token).decimals()));
    _safeMint(msg.sender, currentIdForSale);
    currentIdForSale++;
  }
}