// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

/// @notice Interface from the mpETH token.

interface IStaking {
    function depositETH(address _receiver) external payable returns (uint256);
}