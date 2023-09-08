// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract ZeeToken is ERC20Capped {
    address public owner;

    constructor(uint256 cap) ERC20("ZeeToken", "ZEE") ERC20Capped(cap *(10**decimals())){
        owner = msg.sender;
        _mint(owner, 70000000 * 10**decimals());
    }
}
