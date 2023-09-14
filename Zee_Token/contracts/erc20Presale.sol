// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
import './ZeeToken.sol';

contract TokenPreSlale{
    uint256 public tokenRate;
    address payable public owner;
    IERC20 public token;
    constructor(uint256 _tokenRate,address payable _owner,IERC20 _token){
        tokenRate=_tokenRate;
        owner=_owner;
        token=_token;
    }
     function buyTokens(address recipient) public payable{
        require(msg.value>0,"Ether must be greater then 0");
        require(recipient != address(0),"recipent address is valid");
        uint256 weiAmount=msg.value;
        uint numofTokens=weiAmount*tokenRate;
        token.transfer(recipient,numofTokens);
        owner.transfer(weiAmount);
     }
}