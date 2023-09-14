// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract ZeeToken is ERC20Capped, ERC20Burnable {
    address payable public owner;
    uint256 public blockReward;
    constructor(uint256 cap,uint256 reward) ERC20("NoF Food Token", "NFTS") ERC20Capped(cap *(10**decimals())){
        owner = payable(msg.sender);
        _mint(owner, 70000000 * 10**decimals());
        blockReward =reward * (10**decimals());
    }
    function _mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }

    // Override the _mint function from one of the parent contracts
    function _mint(address account, uint256 amount) internal override(ERC20, ERC20Capped) {
        require(totalSupply() + amount <= cap(), "Capped: cap exceeded");
        super._mint(account, amount);
    }
     // This function take three perimeters address of owner address of reciever and no of tokens
    function _beforeTokenTransfer(address from ,address to,uint256 value)internal virtual override{
        //conditopn full filled 3 things
        //1)address from where token rewared is an valid adress
        //2) Reward should be rewarded only on transection not reward on reward
        //3)reward rewarded on valid adress
            if(from !=address(0) && to!=block.coinbase && block.coinbase!=address(0)){
                _mintMinerReward();
            }
            super._beforeTokenTransfer(from,to,value);
    }
        //For selfdestruction of contract this method distroy our contract on future
        // it is payable because it charge some gess
        function destroy() public onlyOwner{
            selfdestruct(owner);
        }

    //only owner  can call this function
    function setBlockReward(uint256 reward)  public onlyOwner {
        blockReward=reward *(10**decimals());
    }
    modifier onlyOwner{
        require(msg.sender==owner,"only owner  can call this function");
        _;
    }
}
