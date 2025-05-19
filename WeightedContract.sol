// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    uint256 public constant maxSupply = 1_000_000;
    uint256 public constant claimAmount = 100;
    // uint256 public totalClaimed;

    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 quorum);
    error AlreadyVoted();
    error VotingClosed();
    error BurnedIssue();

    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }

    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    struct IssueView {
        address[] voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    Issue[] private issues;
    mapping(address => bool) public hasClaimed;

    constructor() ERC20("BasicTokenC", "TOKENC") {
        issues.push(); // index 0 is burned
    }

    function claim() public {
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }

        if (totalSupply() + claimAmount > maxSupply) {
            revert AllTokensClaimed();
        }

        hasClaimed[msg.sender] = true;
        // totalClaimed += claimAmount;
        _mint(msg.sender, claimAmount);
    }

    function createIssue(string calldata _desc, uint256 _quorum)
        external
        returns (uint256)
    {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }

        if (_quorum > totalSupply()) {
            revert QuorumTooHigh(_quorum);
        }

        Issue storage newIssue = issues.push();
        newIssue.issueDesc = _desc;
        newIssue.quorum = _quorum;

        return issues.length - 1;
    }

    function getIssue(uint256 _id) external view returns (IssueView memory) {
        require(_id < issues.length, "Invalid issue ID");
        Issue storage issue = issues[_id];
        return
            IssueView(
                issue.voters.values(),
                issue.issueDesc,
                issue.votesFor,
                issue.votesAgainst,
                issue.votesAbstain,
                issue.totalVotes,
                issue.quorum,
                issue.passed,
                issue.closed
            );
    }

    function vote(uint256 _issueId, Vote _vote) external {
        if (_issueId == 0) revert BurnedIssue();

        Issue storage issue = issues[_issueId];

        if (issue.closed) {
            revert VotingClosed();
        }
        if (issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }

        uint256 voterBalance = balanceOf(msg.sender);
        if (voterBalance == 0) {
            revert NoTokensHeld();
        }

        issue.voters.add(msg.sender);
        issue.totalVotes += voterBalance;

        if (_vote == Vote.FOR) {
            issue.votesFor += voterBalance;
        } else if (_vote == Vote.AGAINST) {
            issue.votesAgainst += voterBalance;
        } else if (_vote == Vote.ABSTAIN) {
            issue.votesAbstain += voterBalance;
        }

        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            if (issue.votesFor > issue.votesAgainst) {
                issue.passed = true;
            }
        }
    }
}
