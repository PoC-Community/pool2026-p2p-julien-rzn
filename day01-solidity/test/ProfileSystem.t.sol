// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/ProfileSystem.sol";

contract ProfileTest is Test {
    ProfileSystem public system;
    address user1 = address(0x1);
    address user2 = address(0x2);
    function setUp() public {
        system = new ProfileSystem();
    }
    function testCreateProfile() public {
        vm.startPrank(user1);
        system.createProfile("Alice");
        (string memory name, uint256 level, , ) = system.profiles(user1);
        assertEq(name, "Alice");
        assertEq(level, 1);
        vm.stopPrank();
    }
    function testCannotCreateEmptyProfile() public {
        vm.startPrank(user1);
        vm.expectRevert(ProfileSystem.EmptyUsername.selector);
        system.createProfile("");
        vm.stopPrank();
    }
    function testCannotCreateDuplicateProfile() public {
        vm.startPrank(user1);
        system.createProfile("Alice");
        vm.expectRevert(ProfileSystem.UserAlreadyExists.selector);
        system.createProfile("Julien");
        vm.stopPrank();
    }
    function testLevelUp() public {
        vm.startPrank(user1);
        system.createProfile("Alice");
        (, uint256 level, , ) = system.profiles(user1);
        assertEq(level, 1);
        system.levelup();
        (, uint256 levelNext, , ) = system.profiles(user1);
        assertEq(levelNext, 2);
        vm.stopPrank();
    }
    function testCannotLevelUpIfNotRegistered() public {
        vm.startPrank(user1);
        vm.expectRevert(ProfileSystem.UserNotRegistered.selector);
        system.levelup();
        vm.stopPrank();
    }
}
