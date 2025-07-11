// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20, Ownable {

    constructor() ERC20("YashCoin","YSC") Ownable(msg.sender) {
        _mint(msg.sender, 100000000000);
    }

    function mintTo(address _account, uint _amount) public onlyOwner{
        _mint(_account, _amount);
    }

}