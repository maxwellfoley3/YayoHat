pragma solidity =0.5.16;

import "./inherited/ERC20.sol";

contract MockYayoToken is ERC20 {
  constructor(uint numberToMint) ERC20("Yayo", "YAYO") public {
    _mint(msg.sender, numberToMint * 10 ** uint(decimals()));
  }
}
