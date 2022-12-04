// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

import "./IERC1271.sol"; // defined in eip 1271
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LockUpFounders is IERC1271, Ownable {
    using ECDSA for bytes32;
    
    uint256 public initialTime;
    uint256 public tranches;
    uint256 public timeBetweenTranches;
    uint256 public totalLockedValue;
    address public token;

    constructor(address _lockedAddress, address _token, uint256 _tranches, uint256 _daysBetweenTranches, uint256 _totalLockedValue) {
        initialTime = block.timestamp;
        tranches = _tranches;
        token = _token;
        timeBetweenTranches = _daysBetweenTranches*24*60*60;
        totalLockedValue = _totalLockedValue * 10 ** 18;  
        _transferOwnership(_lockedAddress);
    }

    function elapsedTranches()
        public
        view
        returns (uint256)
    {
        uint256 elapsedTime = block.timestamp - initialTime;
        uint256 calculatedTranches = elapsedTime / timeBetweenTranches;
        return calculatedTranches > tranches ? tranches : calculatedTranches;
    }

    function unlockedValue()
        public
        view
        returns (uint256)
    {
        uint256 trancheValue = totalLockedValue / tranches;
        uint256 lockedValue = (tranches - elapsedTranches()) * trancheValue;
        uint256 currentBalance = balance();
        return  currentBalance > lockedValue ? currentBalance - lockedValue : 0;
    }

    function balance()
        public
        view
        returns (uint256)
    {
        return ERC20(token).balanceOf(address(this));
    }

    function withdrawToken()
        public
        onlyOwner
    {
        require(unlockedValue() > 0, "All funds are still locked.");
        ERC20(token).transfer(this.owner(),unlockedValue());
    }

    // MAGICVALUE is defined in eip 1271,
    // as the value to return for valid signatures
    bytes4 internal constant INVALID_SIGNATURE = 0xffffffff;


    // this comes from eip 1271
    function isValidSignature(bytes32 _messageHash, bytes memory _signature)
        public
        view
        override
        returns (bytes4 magicValue)
    {
        address signer = _messageHash.recover(_signature);
        if (
            signer == this.owner()
        ) {
            return MAGICVALUE;
        } else {
            return INVALID_SIGNATURE;
        }
    }

    function votingPower(address _address)
        public
        view
        returns (uint256 votingPowerValue)
    {
        if(
            _address == this.owner()
        ) {
            return balance();
        } else {
            return 0;
        }
        
    }
}
