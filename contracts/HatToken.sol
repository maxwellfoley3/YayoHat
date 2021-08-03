pragma solidity =0.5.16;

import "./ERC20Burnable.sol";

contract HatToken is ERC20Burnable {
  constructor(uint numberToMint) ERC20Burnable("Yayo Hat", "YAYOHAT") public {
    _mint(msg.sender, numberToMint * 10 ** uint(decimals()));
  }
}
