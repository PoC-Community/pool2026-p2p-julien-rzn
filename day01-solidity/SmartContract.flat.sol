// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// src/interfaces/ISmartContract.sol

interface ISmartContract {
    enum roleEnum { STUDENT, TEACHER }
    struct informations {
		string firstName;
		string lastName;
		uint8 age;
		string city;
		roleEnum role;
	}
    event BalanceUpdated(address indexed user, uint256 newBalance);
	error InsufficientBalance(uint256 available, uint256 requested);
    function getHalfAnswerOfLife() external view returns (uint256);
	function getPoCIsWhat() external view returns (string memory);
	function editMyCity(string calldata _newCity) external;
	function getMyFullName() external view returns (string memory);
	function completeHalfAnswerOfLife() external;
	function hashMyMessage(string calldata _message) external pure returns (bytes32);
	function getMyBalance() external view returns (uint256);
	function addToBalance() external payable;
	function withdrawFromBalance(uint256 _amount) external;
}

// src/SmartContract.sol

contract SmartContract is ISmartContract {
	uint256 public halfAnswerOfLife = 21;
	address public myEthereumContractAddress = address(this);
	address public myEthereumAddress = msg.sender;
	string public PoCIsWhat = "PoC is good, PoC is life.";
	bool internal _areYouABadPerson = false;
	int256 private _youAreACheater = -42;
	bytes32 public whoIsTheBest;
	mapping(string => uint256) public myGrades;
	string[5] public myPhoneNumber;
	address private owner;
	informations public myInformations = informations({
		firstName: "Julien",
		lastName: "Ronzon",
		age: 19,
		city: "Lyon",
		role: roleEnum.STUDENT
	});
	function getHalfAnswerOfLife() public view returns (uint256) {
		return halfAnswerOfLife;
	}
	function _getMyEthereumContractAddress() internal view returns (address) {
		return myEthereumContractAddress;
	}
	function getPoCIsWhat() external view returns (string memory) {
		return PoCIsWhat;
	}
	function _setAreYouABadPerson(bool _value) internal {
		_areYouABadPerson = _value;
	}
	function editMyCity(string calldata _newCity) public {
		myInformations.city = _newCity;
	}
	function getMyFullName() public view returns (string memory) {
		return string(abi.encodePacked( myInformations.firstName, " ", myInformations.lastName));
	}
	constructor() {
		owner = msg.sender;
	}
	modifier onlyOwner() {
		require(msg.sender == owner, "Not the owner");
		_;
	}
	function completeHalfAnswerOfLife() public onlyOwner {
		halfAnswerOfLife += 21;
	}
	function hashMyMessage(string calldata _message) public pure returns (bytes32) {
		return keccak256(abi.encodePacked(_message));
	}
	mapping(address => uint256) public balances;
	function getMyBalance() public view returns (uint256) {
		return balances[msg.sender];
	}
	function addToBalance() public payable {
		balances[msg.sender] += msg.value;
		emit BalanceUpdated(msg.sender, balances[msg.sender]);
	}
	function withdrawFromBalance(uint256 _amount) public {
		if (balances[msg.sender] < _amount) {
			revert InsufficientBalance(balances[msg.sender], _amount);
		}
		balances[msg.sender] -= _amount;
		(bool success, ) = msg.sender.call{value: _amount}("");
		require(success, "Transfer failed");
		emit BalanceUpdated(msg.sender, balances[msg.sender]);
	}
}

