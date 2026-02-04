pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/PoolToken.sol";

contract PoolTokenTest is Test {
    PoolToken public token;
    address public owner;
    address public user = address(0x1);
    uint256 public INITIAL_SUPPLY = 1000 ether;

    function setUp() public {
        owner = address(this);
        token = new PoolToken(INITIAL_SUPPLY);
    }
    function testInitialSupply() public {
        assertEq(token.totalSupply(), INITIAL_SUPPLY);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY);
    }

    function testOnlyOwnerCanMint() public {
        vm.prank(user);
        vm.expectRevert();
        token.mint(user, 1000 ether);
    }
}
