// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TimeLockedWallet {
    address public owner;
    address public creator;
    uint256 public unlockDate;
    uint256 public createdAt;

    event Received(address _from, uint256 _amount);
    event Withdrew(address _to, uint256 _amount);
    event WithdrewTokens(address _tokenContract, address _to, uint256 _amount);

    constructor(
        address _creator,
        address _owner,
        uint256 _unlockDate
    ) {
        creator = _creator;
        unlockDate = _unlockDate;
        owner = _owner;
        createdAt = block.timestamp;
    }

    // fallback() external payable {
    //     emit Received(msg.sender, msg.value);
    // }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function info()
        public
        view
        returns (
            address,
            address,
            uint256,
            uint256,
            uint256
        )
    {
        return (creator, owner, unlockDate, createdAt, address(this).balance);
    }

    function withdraw() public onlyOwner {
        require(block.timestamp >= unlockDate);
        payable(msg.sender).transfer(address(this).balance);
        emit Withdrew(msg.sender, address(this).balance);
    }

    function withdrawTokens(address _tokenContract) public onlyOwner {
        require(block.timestamp >= unlockDate, "Wallet is not unlocked yet");
        ERC20 token = ERC20(_tokenContract);
        uint256 tokenBalance = token.balanceOf(address(this));
        token.transfer(owner, tokenBalance);
        emit WithdrewTokens(_tokenContract, msg.sender, tokenBalance);
    }
}
