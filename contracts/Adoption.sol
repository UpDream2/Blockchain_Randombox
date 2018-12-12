pragma solidity ^0.4.17;

contract Adoption {
	struct item {
		address owner;
		uint label;
		uint prev_value;
	}

	item[4] items;

	function Adoption() {
		uint i;
		for(i=0;i<4;i++) {
			//items[i].label = 70;	
			items[i].prev_value = 0;
		}

		items[0].label = 10;	//change value
		items[1].label = 10;	//change value
		items[2].label = 10;	//change value
		items[3].label = 10;	//change value

	}

	//Adopting a pet
	function adopt(uint petId, address _to, uint value) public returns (uint) {
		require(petId >=0 && petId <=15);
		require(value >=0);

		uint cur_temp = items[petId].label - value;
		uint prev_temp = items[petId].label - items[petId].prev_value;

		if(cur_temp < 0) {
			cur_temp = -cur_temp;
		}

		if(prev_temp < 0) {
			prev_temp = -prev_temp;
		}

		if(items[petId].prev_value == 0) {
			items[petId].owner = _to;
			items[petId].prev_value = value;
		}
		else if(cur_temp > prev_temp) {	//prev_temp approach label
		}
		else {
			items[petId].prev_value = value;
			items[petId].owner = _to;
		}

		return petId;
	}

	//Retrieving the adopters
	function getAdopters() public view returns (address[4]) {
		address[4] adopters;
		uint i;
		for(i=0;i<4;i++) {
			adopters[i] = items[i].owner;
		}
		return adopters;
	}

	// result = owner@prev_value@label
	function getResult(uint petId) public view returns (string) {
		string memory results = new string(1);

		require(petId>=0 && petId <=15);

		results = resultToString(petId);
		return results;
	}

	function resultToString(uint petId) public returns (string) {
		bytes memory str = new bytes(50);

		bytes32 b_owner = bytes32(uint(items[petId].owner));
		bytes memory alphabet = "0123456789abcdef";

		uint value = items[petId].prev_value;
		uint temp = value;
		uint length;
		uint length2;

		str[0] = '0';
		str[1] = 'x';

		for(uint i=0;i<20;i++) {	// address convert to hex data
			str[i*2+2] = alphabet[uint(b_owner[i + 12] >> 4)];
			str[i*2+3] = alphabet[uint(b_owner[i + 12] & 0x0f)];
		}

		str[42] = '@';			//seperator character

		while(temp!=0) {		//prev_value ( approach label score ) 
			length++;
			temp = temp/10;
		}

		temp = length-1;

		while(value != 0) {
			str[43+ (temp--)] = byte(48 + value % 10);
			value = value/10;
		}
		str[43+length] = '@';

		value = items[petId].label;
		temp = value;

		while(temp!=0) {		// label
			length2++;
			temp = temp/10;
		}

		temp = length2 -1;

		while(value != 0) {
			str[44+ length + (temp--)] = byte(48 + value % 10);
			value = value/10;
		}

		return string(str);
	}

}

