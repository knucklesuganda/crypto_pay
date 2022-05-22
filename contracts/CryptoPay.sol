// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;


import "./UserManager.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract CryptoPay{

    UserManager public userManager;

    constructor(){
        userManager = new UserManager();
    }

    function getUser(string memory nickname) private view returns(address) {
        address foundUser = userManager.getUserByNickname(nickname);
        require(foundUser != address(0), "User not found");
        return foundUser;
    }

    // Native token pay
    function sendEth(string memory nickname) external payable {
        address foundUser = getUser(nickname);

        (bool isSent, ) = foundUser.call{value: msg.value}("");
        require(isSent, "Unable to sent native tokens");

    }

    // ERC20 pay
    function sendERC20(string memory nickname, address tokenAddress, uint amount) external {

        address foundUser = getUser(nickname);
        ERC20 token = ERC20(tokenAddress);
        token.transferFrom(msg.sender, foundUser, amount);
        // require(isSent, "Unable to sent tokens");

    }

}
