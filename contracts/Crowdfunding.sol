// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Crowdfunding {
    address public owner;
    uint public goal;
    uint public totalFunds;

    mapping(address => uint) public contributions;

    constructor(uint _goal) {
        owner = msg.sender;
        goal = _goal;
    }

    // Function 1: Allow users to contribute funds
    function contribute() public payable {
        require(msg.value > 0, "Must send ETH to contribute");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
    }

    // Function 2: Allow owner to withdraw funds if goal is reached
    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(totalFunds >= goal, "Goal not reached yet");

        payable(owner).transfer(address(this).balance);
    }

    // Function 3: Allow contributors to get refund if goal not reached
    function refund() public {
        require(totalFunds < goal, "Goal was reached, refund not possible");

        uint amount = contributions[msg.sender];
        require(amount > 0, "No contribution to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}

