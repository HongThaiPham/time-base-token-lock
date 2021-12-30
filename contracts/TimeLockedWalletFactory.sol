// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./TimeLockedWallet.sol";

contract TimeLockedWalletFactory {
    mapping(address => address[]) wallets;

    event Created(
        address wallet,
        address from,
        address to,
        uint256 createdAt,
        uint256 unlockDate,
        uint256 amount
    );

    function getWallets(address _user) public view returns (address[] memory) {
        return wallets[_user];
    }

    function newTimeLockedWallet(address _owner, uint256 _unlockDate)
        public
        payable
        returns (address wallet)
    {
        wallet = address(new TimeLockedWallet(msg.sender, _owner, _unlockDate));
        wallets[msg.sender].push(wallet);
        if (msg.sender != _owner) {
            wallets[_owner].push(wallet);
        }
        payable(wallet).transfer(msg.value);
        emit Created(
            wallet,
            msg.sender,
            _owner,
            block.timestamp,
            _unlockDate,
            msg.value
        );
    }
}
