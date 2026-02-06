// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/PoolToken.sol";
import "../src/VaultGovernor.sol";

contract VaultGovernorTest is Test {
    VaultGovernor public governor;
    PoolToken public token;
    address public owner = address(1);
    address public alice = address(2);
    uint256 public constant INITIAL_SUPPLY = 1000000e18;
    uint256 public constant VOTING_DELAY = 1;
    uint256 public constant VOTING_PERIOD = 50;
    uint256 public constant QUORUM_PERCENTAGE = 4;

    function setUp() public {
        vm.startPrank(owner);
        token = new PoolToken(INITIAL_SUPPLY);
        governor = new VaultGovernor(IVotes(address(token)), VOTING_DELAY, VOTING_PERIOD, QUORUM_PERCENTAGE);
        token.transfer(alice, 100000e18);
        vm.stopPrank();
    }
    function testGovernorParameters() public {
        assertEq(governor.votingDelay(), VOTING_DELAY);
        assertEq(governor.votingPeriod(), VOTING_PERIOD);
        assertEq(governor.name(), "VaultGovernor");
    }
    function testQuorumCalculation() public {
        vm.prank(owner);
        token.delegate(owner);
        vm.roll(block.number + 1);
        uint256 quorumTest = governor.quorum(block.number - 1);
        assertEq(quorumTest, 40000e18);
    }
    function testCreateProposal() public {
        vm.prank(alice);
        token.delegate(alice);
        vm.roll(block.number + 1);
        address[] memory targets = new address[](1);
        targets[0] = address(0);
        uint256[] memory values = new uint256[](1);
        values[0] = 0;
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = "";
        string memory description = "Test proposal";
        vm.prank(alice);
        uint256 proposalID = governor.propose(targets, values, calldatas, description);
        assertGt(proposalID, 0);
    }
}
