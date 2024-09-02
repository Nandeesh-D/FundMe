// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"; // corrected import path
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    AggregatorV3Interface public s_priceFeed;
    uint256 public constant MINIMUM_USD = 5 * 1e18;
    // address of the owner of the organization
    address public immutable i_owner;
    // to store the funders
    address[] public s_funders;

    // to map the contribution of each sender
    mapping(address => uint256) public s_addressToAmountFunded; // fixed mapping syntax

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed=AggregatorV3Interface(priceFeed);
    }

    modifier onlyOwner() {
        // reduces the gas
        if (msg.sender != i_owner) {
            // fixed the logic, it should check if not the owner
            revert NotOwner();
        }
        _;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "Not enough Ether sent"
        ); // added argument to getConversionRate
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        // first reset the amount contributed by funders to 0
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            s_addressToAmountFunded[s_funders[funderIndex]] = 0;
        }

        // resetting the address (funders) array
        s_funders = new address[](0);

        // withdraw amounts
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);

        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    function getAmountFunded(address funder) public view returns (uint256) {
        return s_addressToAmountFunded[funder];
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }

    // to handle direct sends
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
