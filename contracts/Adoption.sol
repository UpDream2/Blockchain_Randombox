pragma solidity ^0.4.17;

contract Adoption {
	address[16] public adopters;	// pet ID 
	address[16] ownership;	//ownership , cmjeong add
	//mapping (address => uint256 ) public balanceOf;

	//Adopting a pet
	function adopt(uint petId) public returns (uint) {
		require(petId >=0 && petId <=15);
		adopters[petId] = msg.sender;
		ownership[petId] = msg.sender;	//cmjeong add

		return petId;
	}

	//Retrieving the adopters
	function getAdopters() public view returns (address[16]) {
		return adopters;
	}

	// cmjeong add getOwnership() 
	function getOwnership() public view returns (address[16]) {
		return ownership;
	}
}

