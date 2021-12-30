// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";

contract TokenLock is ERC20, Ownable {
    constructor() ERC20("Token Lock", "TKL") {
        _mint(msg.sender, 1000000 * 10**decimals());
    }
}
