// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LibertarianUniverseToken is ERC20, Ownable {

    uint256 public initialTime;
    uint256 public tranche;

    constructor() ERC20("Libertarian Universe Token", "LUT") {
        initialTime = block.timestamp;
        tranche = 0;
        _mint(msg.sender, 600000 * 10 ** decimals());
    }

    function mintTranche1() public {
        uint256 elapsedTime = block.timestamp - initialTime;
        require(elapsedTime >= 365 days, "It's not time yet.");
        require(this.totalSupply() == 600000 * 10 ** decimals(), "Already minted.");
        _mint(this.owner(), 150000 * 10 ** decimals());
        tranche++;  
    }

    function mintTranche2() public {
        uint256 elapsedTime = block.timestamp - initialTime;
        require(tranche >= 1, "You need to mint Tranche 1 to mint this one.");
        require(elapsedTime >= 730 days, "It's not time yet.");
        require(this.totalSupply() == 750000 * 10 ** decimals(), "Already minted.");
        _mint(this.owner(), 150000 * 10 ** decimals());
        tranche++;
    }

    function mintTranche3() public {
        uint256 elapsedTime = block.timestamp - initialTime;
        require(tranche >= 2, "You need to mint Tranche 2 to mint this one.");
        require(elapsedTime >= 1095 days, "It's not time yet.");
        require(this.totalSupply() == 900000 * 10 ** decimals(), "Already minted.");
        _mint(this.owner(), 100000 * 10 ** decimals());
        tranche++;        
    }


}
