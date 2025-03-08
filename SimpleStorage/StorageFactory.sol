// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

// okay, i think its just looking for the cotnract folder
contract SimpleStorage {

    uint256 public myFavouriteNumber;

    uint256[] listofFavouriteNumbers; 

    struct Person {
        uint256 favouriteNumber;
        string name;
    }
    // okay post on linkedin. // SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { SimpleStorage } from "./SimpleStorage.sol";


contract StorageFactory {

    SimpleStorage[] public listOfSimpleStorageContracts;

    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorage = new SimpleStorage();
        listOfSimpleStorageContracts.push(newSimpleStorage);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber) public {
        SimpleStorage mySimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];
        mySimpleStorage.store(_newSimpleStorageNumber);
    }
    
    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        SimpleStorage mySimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];
        return mySimpleStorage.retrieve();
    }

}


    // Person[3] -> static array 
    // dynamic array
    Person[] public listOfPeople;

    Person public pat = Person({
        favouriteNumber: 7, 
        name: "Pat"
    });
    // okay wait. let me connect
    // "jw" -> 99
    mapping(string => uint256) public nameToFavouriteNumber;

    function store(uint256 _favouriteNumber) public virtual {
        myFavouriteNumber = _favouriteNumber;
    }

    // the same as making it public -> auto getter method created
    function retrieve() public view returns(uint256) {
        return myFavouriteNumber;
    }

    function addPerson(string memory _name, uint256 _favouriteNumber) public {
        listOfPeople.push(Person({name: _name, favouriteNumber: _favouriteNumber}));
        nameToFavouriteNumber[_name] = _favouriteNumber;
    }
}

// Learnings
// 1. view function will cost gas if its used by a function that changes state of the smart contract
// 2. calldata (temp, cannot be modified)
//    memory (temp,  can still be modified) - eg. addPerson(string memory name) -> this is an array of bytes so it needs memmory
//    storage (perm, can be modified)

// video lagging
// Qn: ehhh we can also set as calldata right? Since it also works. Yeah
// but in this case...
// so stupid. 