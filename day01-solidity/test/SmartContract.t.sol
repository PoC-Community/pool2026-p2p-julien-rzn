// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/SmartContract.sol";

contract SmartContractHelper is SmartContract {
	function getAreYouABadPerson() public view returns (bool) {
		return _areYouABadPerson;
	}
}

contract SmartContractTest is Test {
    SmartContract public smartContract;
    SmartContractHelper public helper;
	function setUp() public {
        smartContract = new SmartContract();
        helper = new SmartContractHelper();
    }
	function testGetHalfAnswerOfLife() public {
		uint256 result = smartContract.getHalfAnswerOfLife();
		assertEq(result, 21);
	}
    function testInternalVariable() public{
        bool result = helper.getAreYouABadPerson();
        assertEq(result, false);
    }
    function testStructData() public {
        (
            string memory firstName,
            string memory lastName,
            uint8 age,
            string memory city,
            SmartContract.roleEnum role
        ) = helper.myInformations();
        assertEq(firstName, "Julien");
        assertEq(lastName, "Ronzon");
        assertEq(age, 19);
        assertEq(city, "Lyon");
        assertTrue(role == ISmartContract.roleEnum.STUDENT);
	}
}
