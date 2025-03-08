// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { SimpleStorage } from "./SimpleStorage.sol";

contract AddFiveSimpleStorage is SimpleStorage {

    function store(uint256 _favouriteNumber) public override  {
        myFavouriteNumber = _favouriteNumber +5;
    }

}