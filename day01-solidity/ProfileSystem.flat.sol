// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// src/ProfileSystem.sol

contract ProfileSystem {
    event ProfileCreated(address indexed user, string username);
    event LevelUp(address indexed user, uint256 newLevel);
    enum Role { GUEST, USER, ADMIN }
    struct UserProfile {
        string username;
        uint256 level;
        uint256 lastUpdated;
        Role role;
    }
    mapping(address => UserProfile) public profiles;
    error UserAlreadyExists();
    error EmptyUsername();
    error UserNotRegistered();
    modifier onlyRegistered() {
        if (profiles[msg.sender].level == 0) {
            revert UserNotRegistered();
        }
        _;
    }
    function createProfile(string calldata _name) external {
        require(bytes(_name).length != 0, "error empty");
        //if (bytes(_name).length == 0) {
        //    revert EmptyUsername();
        //}
        UserProfile storage profile = profiles[msg.sender];
        require(profile.level == 0, "error already_exist");
        //if (profile.level != 0) {
        //    revert UserAlreadyExists();
        //}
        profile.username = _name;
        profile.level = 1;
        profile.role = Role.USER;
        profile.lastUpdated = block.timestamp;
        emit ProfileCreated(msg.sender, _name);
    }
    function levelup() external onlyRegistered {
        UserProfile storage profile = profiles[msg.sender];
        profile.level += 1;
        profile.lastUpdated = block.timestamp;
        emit LevelUp(msg.sender, profile.level);
    }
}

