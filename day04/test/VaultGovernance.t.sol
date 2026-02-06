// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/Vault.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MonToken is ERC20 {
    constructor() ERC20("Mon token", "JSP") {
        _mint(msg.sender, 10000e18);
    }
}

contract VaultGovernanceTest is Test {
    Vault vault;
    MonToken token;
    address alice = makeAddr("alice");
    address owner;
    event WithdrawalFeeUpdated(uint256 oldFee, uint256 newFee);
    function setUp() public {
        owner = address(this);
        token = new MonToken();
        vault = new Vault(address(token));
        token.transfer(alice, 1000e18);
    }
    function testReward() public {
        vm.startPrank(alice);
        token.approve(address(vault), 1000e18);
        vault.deposit(1000e18);
        vm.stopPrank();
        token.approve(address(vault), 100e18);
        vault.addReward(100e18);
        vm.prank(alice);
        uint256 received = vault.withdrawAll();
        assertEq(received, 1100e18);
    }
    function testSetWithdrawalFee() public {
        address governor = makeAddr("governor");
        vm.prank(owner);
        vault.setGovernor(governor);
        uint256 newFee = 250;
        vm.expectEmit(true, true, true, true);
        emit WithdrawalFeeUpdated(0, newFee);
        vm.prank(governor);
        vault.setWithdrawalFee(newFee);
        assertEq(vault.withdrawalFeeBps(), newFee);
    }
    function testNonGovernorCannotSetFee() public {
        address nongovernor = makeAddr("nongovernor");
        uint256 newFee = 250;
        vm.expectRevert(Vault.OnlyGovernor.selector);
        vm.prank(nongovernor);
        vault.setWithdrawalFee(newFee);
    }
    function testFeeCannotExceedMax() public {
        address governor = makeAddr("governor");
        vm.prank(owner);
        vault.setGovernor(governor);
        uint256 newFee = 1500;
        vm.expectRevert(Vault.FeeTooHigh.selector);
        vm.prank(governor);
        vault.setWithdrawalFee(newFee);
    }
    function testWithdrawalWithFee() public {
        vm.startPrank(alice);
        token.approve(address(vault), 1000e18);
        vault.deposit(1000e18);
        vm.stopPrank();
        address governor = makeAddr("governor");
        vm.prank(owner);
        vault.setGovernor(governor);
        vm.prank(governor);
        vault.setWithdrawalFee(250);
        vm.prank(alice);
        uint256 received = vault.withdrawAll();
        assertEq(received, 975e18);
        assertEq(vault.totalAssets(), 25e18);
    }
}
