pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event Approval(address indexed owner, address indexed spender, uint256 value);
  event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

  YourToken public yourToken;
  uint256 public constant tokensPerEth = 100;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
function buyTokens() public payable {
        // Calculate the number of tokens to be bought
        uint256 amountOfTokens = msg.value * tokensPerEth;

        // Ensure the Vendor contract has enough tokens to sell
        require(yourToken.balanceOf(address(this)) >= amountOfTokens, "Vendor: Not enough tokens available");

        // Transfer tokens to the buyer
        yourToken.transfer(msg.sender, amountOfTokens);

        // Emit the event for the token purchase
        emit BuyTokens(msg.sender, msg.value, amountOfTokens);
    }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
function withdraw() public onlyOwner {
     uint256 contractBalance = address(this).balance;
     require(contractBalance > 0, "Vendor: No ETH available for withdrawal");

     // Transfer all ETH to the owner
     payable(owner()).transfer(contractBalance);
 }

  // ToDo: create a sellTokens(uint256 _amount) function:
function sellTokens(uint256 _amount) public {

        // Ensure the user has enough tokens to sell
        require(yourToken.balanceOf(msg.sender) >= _amount, "Vendor: Not enough tokens to sell");

        // Calculate the amount of ETH to transfer
        uint256 amountOfETH = _amount / tokensPerEth;

        // Ensure the Vendor contract has enough ETH to buy the tokens
        require(address(this).balance >= amountOfETH, "Vendor: Not enough ETH available");

        // Perform the token transfer from the user to the Vendor
        // This requires the user to have called approve() first
        require(yourToken.allowance(msg.sender, address(this)) >= _amount, "Vendor: Allowance not set for this amount");
         yourToken.transferFrom(msg.sender, address(this), _amount);

        // Transfer ETH to the user
        payable(msg.sender).transfer(amountOfETH);

        // Emit an event for the token sale
        emit SellTokens(msg.sender, _amount, amountOfETH);  

}
}
