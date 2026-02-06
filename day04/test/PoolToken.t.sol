// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/PoolToken.sol";

contract PoolTokenVoteTest is Test {
    PoolToken public token;
    address public owner = address(1);
    address public alice = address(2);
    address public bob = address(3);
    uint256 public constant INITIAL_SUPPLY = 1000000e18;

    function setUp() public {
        vm.prank(owner);
        token = new PoolToken(INITIAL_SUPPLY);
        vm.startPrank(owner);
        token.transfer(alice, 100000e18);
        token.transfer(bob, 50000e18);
        vm.stopPrank();
    }
    function testInitialVotingPowerIsZero() public {
        uint256 aliceToken = token.balanceOf(alice);
        assertGt(aliceToken, 0, "Alice don't have tokens");
        uint256 aliceVotes = token.getVotes(alice);
        assertEq(aliceVotes, 0, "Alice have 0 voting power");
    }
    function testDelegateToSelf() public {
        vm.prank(alice);
        token.delegate(alice);
        uint256 aliceVotes = token.getVotes(alice);
        uint256 aliceToken = token.balanceOf(alice);
        assertEq(aliceVotes, aliceToken);
    }
    function testDelegateToOther() public {
        vm.prank(alice);
        token.delegate(bob);
        uint256 aliceVotes = token.getVotes(alice);
        assertEq(aliceVotes, 0);
        uint256 bobVotes = token.getVotes(bob);
        uint256 aliceToken = token.balanceOf(alice);
        assertEq(bobVotes, aliceToken);
    }
    function testGetPastVotes() public {
        uint256 pastBlock = block.number;
        vm.prank(alice);
        token.delegate(alice);
        vm.roll(block.number + 1);
        uint256 aliceToken = token.balanceOf(alice);
        uint256 pastVotes = token.getPastVotes(alice, pastBlock);
        assertEq(pastVotes, aliceToken);
    }
}
