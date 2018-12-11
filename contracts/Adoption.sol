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

	//function getResult() public view returns (address[4] ) {
	//}

}

