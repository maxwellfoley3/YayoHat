pragma solidity =0.5.16;
import './YayoSwap.sol';
import './MockYayoToken.sol';
import './HatToken.sol';
import "./inherited/SafeMath.sol";

contract YayoSwapRouter { 
  using SafeMath for uint;

  address yayoSwapAddress;
  address mockYayoTokenAddress;
  address hatTokenAddress;

  constructor(address _yayoSwapAddress, address _mockYayoTokenAddress, address _hatTokenAddress ) public {
    yayoSwapAddress = _yayoSwapAddress;
    mockYayoTokenAddress = _mockYayoTokenAddress;
    hatTokenAddress = _hatTokenAddress;
  }

  modifier ensure(uint deadline) {
    require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
    _;
  }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
  function getAmountYayoOut(uint amountIn) public view returns (uint amountOut) {
      require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
      uint reserveIn;
      uint reserveOut;
      (reserveOut, reserveIn, ) = YayoSwap(yayoSwapAddress).getReserves();
      require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
      uint amountInWithFee = amountIn.mul(997);
      uint numerator = amountInWithFee.mul(reserveOut);
      uint denominator = reserveIn.mul(1000).add(amountInWithFee);
      amountOut = numerator / denominator;
  }

  // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
  function getAmountYayoIn(uint amountOut) public view returns (uint amountIn) {
      require(amountOut > 0, 'YayoSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
      uint reserveIn;
      uint reserveOut;
      (reserveIn, reserveOut, ) = YayoSwap(yayoSwapAddress).getReserves();
      require(reserveIn > 0 && reserveOut > 0, 'YayoSwapRouter: INSUFFICIENT_LIQUIDITY');
      uint numerator = reserveIn.mul(amountOut).mul(1000);
      uint denominator = reserveOut.sub(amountOut).mul(997);
      amountIn = (numerator / denominator).add(1);
  }

  function swapYayoForExactHat(
      uint amountOut,
      uint amountInMax,
      address to,
      uint deadline
  ) external ensure(deadline) {
      uint amountIn = getAmountYayoIn(amountOut);
      require(amountIn <= amountInMax, 'YayoSwapRouter: EXCESSIVE_INPUT_AMOUNT');
      MockYayoToken(mockYayoTokenAddress).transferFrom(msg.sender, yayoSwapAddress, amountIn);
      YayoSwap(yayoSwapAddress).swap(0, amountOut, to);
  }

  function swapExactHatForYayo(
      uint amountIn,
      uint amountOutMin,
      address to,
      uint deadline
  ) external ensure(deadline) {
      uint amountOut = getAmountYayoOut(amountIn);
      require(amountOut >= amountOutMin, 'YayoSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
      HatToken(hatTokenAddress).transferFrom(msg.sender, yayoSwapAddress, amountIn);
      YayoSwap(yayoSwapAddress).swap(amountOut, 0, to);
  }

}