// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {

    uint256 public initialTime;

    constructor() ERC20("Libertarian Universe Token", "LUT") {
        initialTime = block.timestamp;
        _mint(msg.sender, 600000 * 10 ** decimals());
    }

    function mintOnTime() public {
        uint256 elapsedTime = block.timestamp - initialTime;
        if(elapsedTime >= 365 days && this.totalSupply() == 600000 * 10 ** decimals()){
            _mint(this.owner(), 150000 * 10 ** decimals());
        }
        if(elapsedTime >= 730 days && this.totalSupply() == 750000 * 10 ** decimals()){
            _mint(this.owner(), 150000 * 10 ** decimals());
        }
        if(elapsedTime >= 1095 days && this.totalSupply() == 900000 * 10 ** decimals()){
            _mint(this.owner(), 100000 * 10 ** decimals());
        }
    }

}
