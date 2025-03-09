
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { PriceConverter } from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MIN_USD = 5e18; // 5usd

    address[] public funders;

    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MIN_USD, "didn't send enough Eth");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the array
        funders = new address[](0);
        // 3 methods to do the fund sending
        // 1. transfer (throws error if fail) (caps at 2300 gas)
        // payable(msg.sender).transfer(address(this).balance);
        // 2. send (need to do require so that it reverts above) (caps at 2300 gas)
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "failed to send eth");
        // 3. call - low level
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "call failed");
    }

    modifier onlyOwner() {
        if (msg.sender == i_owner) {revert NotOwner(); }
        _; // this means continue whatever else in this function
    }

    receive() external payable {
        fund();
    }
    
    fallback() external payable {
        fund();
    }
}

// Lessons:
// 1. 'payable' keyword. And use msg.value (wei) to access
// 2. If you executed a failed transaction, you still spend gas because some lines were executed. But its atomic, so state changes in earlier codes will be reverted
// 3. chainlink is decentralized oracle network (data.chain.link)
// 4. chainlink keepers are like cron/workers that listen for events (e.g. liquidity pool below certain level)
// 5. AggregatorV3Interface(address) is saying that the contract address has this aggregatorv3 interface
// 6. chainlink returns in 8 decimals and we need to convert to decimals of token. 
// 7. Do multiplication first instead of division. Solidity cannot handle decimals.
// 8. msg.value returns in wei. Handle the e18 decimals
// 9. You can create a library then doing `using PriceConverter for uint256` means that all uint256 has access to its functions!
// 10. SafeMath is deprecated after solidity 0.8.0 because overflow and underflow checks are now in built. But you can still do uncheck for gas efficiency purposes
// 11. 3 ways of doing transaction. i) transfer; ii) send; iii) call
// 12. creating modifier (like middlewares)
// 13. use constant and immutable to reduce gas cost. Save around ~20k gas cost for each
// 14. custom errors save cost further. Saves ~24k gas cost for each. Because smart contract does not need to store the string
// 15. receive() special function. Triggered when CALLDATA is empty
// 16. fallback() special function. Triggered when CALLDATA is populated or if there is no receive()

// Other things to learn:
// 1. Enums
// 2. Events
// 3. Try/ Catch
// 4. Function Selectors
// 5. abi.encode / decode
// 6. Hashing
// 7. Yul/ Assembly