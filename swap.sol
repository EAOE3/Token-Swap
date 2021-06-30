// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface IERC20{
    
    function transfer(address recipient, uint256 amount) external returns(bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);
}

interface MCHstakingInterface {

    function showBlackUser(address user) external view returns(bool) ;
}

interface swapInterface{
    
    function swap(uint256 amount) external;
    
    function withdraw(uint256 amount) external;
}

contract swapContract is swapInterface {
    
    IERC20 oldToken;
    IERC20 newToken;
    MCHstakingInterface staking;
    
    address _owner;
    
    constructor(address oldOne, address newOne, address MCHstakingContract){
        oldToken = IERC20(oldOne);
        newToken = IERC20(newOne);
        staking = MCHstakingInterface(MCHstakingContract);
        _owner = msg.sender;
    }
    
    function swap(uint256 amount) external override {
        oldToken.transferFrom(msg.sender, address(this), amount);
        if(staking.showBlackUser(msg.sender)){return;}
        newToken.transfer(msg.sender, amount);
    }
    
    function withdraw(uint256 amount) external override {
        require(msg.sender == _owner);
        newToken.transfer(msg.sender, amount);
    }
}
