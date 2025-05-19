// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

error TokensClaimed();
error AllTokensClaimed();
error UnsafeTransfer(address account);

contract UnburnableToken {
    mapping(address => uint256) public balances;
    uint256 public totalSupply;
    uint256 public totalClaimed;
    uint256 public constant CLAIM_AMOUNT = 1000;

    constructor() {
        totalSupply = 100000000;
    }

    function claim() public {
        if (totalClaimed >= totalSupply) {
            revert AllTokensClaimed();
        }

        if (balances[msg.sender] > 0) {
            revert TokensClaimed();
        }

        balances[msg.sender] = CLAIM_AMOUNT;
        totalClaimed += CLAIM_AMOUNT;
    }

    function safeTransfer(address _to, uint256 _amount) public {
        if (_to == address(0)) {
            revert UnsafeTransfer(_to);
        }

        if (_to.balance == 0) {
            revert UnsafeTransfer(_to);
        }

        if (balances[msg.sender] < _amount || _amount == 0) {
            revert UnsafeTransfer(msg.sender);
        }

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
