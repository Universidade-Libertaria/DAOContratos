//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IERC20 {
    function transfer(address to, uint amount) external;
    function decimals() external view returns(uint);
    function balanceOf(address _address) external view returns(uint);
}

contract TokenSale is Ownable {
    uint public tokenPriceInETH = 1000;
    

    IERC20 token;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function purchase() public payable {
      uint tokenPriceInWei = 1 ether / tokenPriceInETH;
      require(msg.value >= tokenPriceInWei, "Not enough money sent");
      uint tokensToTransfer = msg.value / tokenPriceInWei;
      uint remainder = msg.value - tokensToTransfer * tokenPriceInWei;
      token.transfer(msg.sender, tokensToTransfer * 10 ** token.decimals());
      payable(msg.sender).transfer(remainder); //send the rest back

    }

    function changePrice(uint _newPriceInETH) public onlyOwner {
      tokenPriceInETH = _newPriceInETH;
    }

    function withdrawETH(uint _amount, address payable _withdrawAddress) public payable onlyOwner {
      _withdrawAddress.transfer(_amount);
    }

    function withdrawToken(uint _amount, address payable _withdrawAddress) public onlyOwner {
      token.transfer(_withdrawAddress,_amount);
    }

    function getTokenBalance() public view returns (uint) {
      return token.balanceOf(address(this));
    }

    receive() external payable {
      purchase();
    }
    
    fallback() external payable {
      purchase();
    }
}
