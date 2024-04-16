// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MpEthToken is ERC20 {
    constructor(
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) {}

    function depositETH(address _receiver) external payable returns (uint256) {
        require(msg.value > 0);
        _mint(_receiver, msg.value);
        payable(msg.sender).transfer(msg.value);
        return msg.value;
    }
}
