pragma solidity ^0.4.4;

import "GarantContract.sol";

contract DealsList {

    address owner;
	uint num_items = 0;


	/**
	 * Base struct for a single List Item
	 */
    struct ListItem {
    	string name;
     	bool state;
     	address garant;
    	string kadastr;
    	string adrname;
    	string price;
    	string real_price;
    	string seller_name;
    	string seller_pasport;
    	string bayer_name;
    	string bayer_pasport;
    	address garant_contract;
    }

	/**
	 * A struct for items
	 */
    struct Items {
      	mapping(uint => ListItem) ListItems;
    }

	/**
	 * A mapping of several items
	 */
    mapping(address => Items) list_items;

    /**
     * Constructor
     */
    function DealsList() {
      	owner = msg.sender;
    }

	/**
	 * Returns list items for index
	 * @param index The index of the item
	 * @return string, bool
	 */
	function getItemForIndex(uint index) constant returns (string, bool) {
		return (list_items[msg.sender].ListItems[index].kadastr, list_items[msg.sender].ListItems[index].state);
	}

	/**
	 * Sets a single list item for index
	 * @param index The index of the item
	 */
	function setItemForIndex(uint index, string _name, bool _state) {

		list_items[msg.sender].ListItems[index].name  = _name;
		this.setStateForItemAtIndex(index, _state);

		// Increment the number of items counter
		num_items++;
	}

	/**
	 * Sets state for item at index
	 * @param index uint
	 * @param _state bool
	 */
	function setStateForItemAtIndex(uint index, bool _state) {
		list_items[msg.sender].ListItems[index].state = _state;
	}

	/**
	 * Updates item at index and moves all items after that one one index back
	 * @param index uint
	 */
	function removeItemAtIndex(uint index) {

		/*
		 * TODO - Currently a bad solution! Find a better way to delete
		 *
		 * the "delete list_items[msg.sender].ListItems[i]" statement did
		 * NOT work as expected.
		 *
		 */

		if ( (index > num_items) || (index < 0) )
		{
			// Do nothing
		}
		else
		{
			for (uint i = index; i <= (num_items-1); i++) {
				list_items[msg.sender].ListItems[i] = list_items[msg.sender].ListItems[i+1];
			}

			num_items--;
		}

		// Just a failsafe
		if (num_items <= 0)
		{
			num_items = 0;
		}
	}

	/**
	 * Returns the number if items
	 * @return uint
	 */
	function returnNumItems() constant returns (uint) {
		return num_items;
	}

	/**
	 * Kills the List, yo.
	 * Only allows this for the owner
	 */
	function killList() {
	  	if ( msg.sender == owner )
	    	suicide(owner);
	}




	function approve() constant returns(address GarantAddr) {
		address contractGarant = address(new GarantContract());
		list_items[msg.sender].ListItems[0].garant_contract = contractGarant;
		contractGarant;
	}
	
}