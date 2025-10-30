// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrowdFund {
    address public owner;
    uint public goal;
    uint public totalFunds;
    uint public deadline;

    mapping(address => uint) public contributions;

    constructor(uint _goal, uint _durationInDays) {
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + (_durationInDays * 1 days);
    }

    // Function 1: Contribute to the campaign
    function contribute() public payable {
        require(block.timestamp < deadline, "Campaign has ended");
        require(msg.value > 0, "Must send some ETH");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
    }

    // Function 2: Withdraw funds (only if goal reached)
    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(totalFunds >= goal, "Funding goal not reached yet");
        require(block.timestamp >= deadline, "Cannot withdraw before deadline");

        uint amount = totalFunds;
        totalFunds = 0;
        payable(owner).transfer(amount);
    }

    // Function 3: Check if goal reached
    function goalReached() public view returns (bool) {
        return totalFunds >= goal;
    }

    // Function 4: Refund contributors if goal not reached after deadline
    function refund() public {
        require(block.timestamp > deadline, "Campaign still active");
        require(totalFunds < goal, "Goal was reached, no refunds");

        uint contributed = contributions[msg.sender];
        require(contributed > 0, "No funds to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(contributed);
    }

    // Function 5: Get remaining time
    function getTimeLeft() public view returns (uint) {
        if (block.timestamp >= deadline) {
            return 0;
        } else {
            return deadline - block.timestamp;
        }
    }
}
