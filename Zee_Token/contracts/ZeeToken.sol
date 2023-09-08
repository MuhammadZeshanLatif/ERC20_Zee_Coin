// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

 contract ZeeToken is ERC20{
     constructor(uint initialSupply) ERC20("ZeeToken","ZEE"){
    _mint(msg.sender, initialSupply);
     }
 }