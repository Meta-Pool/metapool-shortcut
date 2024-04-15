// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @notice Interface from the mpETH token.

interface IStaking is IERC20 {
    function depositETH(address _receiver) external payable returns (uint256);
}