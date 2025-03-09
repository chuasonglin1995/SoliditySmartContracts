
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { AggregatorV3Interface } from "@chainlink/contracts@1.3.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {

    function getEthPrice() internal view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int256 price,,,) = priceFeed.latestRoundData();
        // Chainlink price feeds return prices with 8 decimals (e.g., ETH/USD might return 35001234567, which is $3500.1234567).
        // Multiplying by 1e10 (10^10) converts the 8-decimal price into a standard 18-decimal format.
        return uint256(price * 1e10);
    }

    //
    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getEthPrice();
        uint256 ethAmountInUsd = ethAmount * ethPrice / 1e18;
        return ethAmountInUsd;
    }
   
}