// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IStaking} from "./interfaces/IStaking.sol";
import {ITokenBridge} from "./interfaces/ITokenBridge.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/// @title Meta Pool Shorcut -> Swap mainnet ETH for mpETH on Linea (L2)

contract SwapToMpEthOnLineaV1 is OwnableUpgradeable {
    using SafeERC20 for IERC20;

    uint256 public chainId;
    address public bridge;
    address public mpeth;

    uint256 public constant COMPLEXITY = 2;
    uint256 public constant BASE_FEE = 1000;

    error LessThanMinValue();
    error UnsuccessfulApproval();

    event NewSwapToMpEthOnLinea(address indexed _receiver, uint256 _amount);

    /// @param _chainId eip-1344 Chain ID is a 256-bit value
    function initialize(
        uint256 _chainId,
        address _bridge,
        address _mpeth,
        address _owner
    ) public initializer {
        __Ownable_init(_owner);
        chainId = _chainId;
        bridge = _bridge;
        mpeth = _mpeth;
    }

    function updateBridgeAddress(address _bridge) external onlyOwner returns (bool) {
        bridge = _bridge;
        return true;
    }

    /// @notice the owner receives the fee.
    function _chargeFee(uint256 amount) private returns (uint256) {
        if (owner() == address(0)) {
            return 0;
        } else {
            // owner() != address(0)
            uint256 fee = (amount * COMPLEXITY) / BASE_FEE;
            IERC20(mpeth).safeTransfer(owner(), fee);
            return fee;
        }
    }

    receive() external payable {
        if (msg.value < 0.01 ether) revert LessThanMinValue();

        // stake eth -> mpEth
        uint256 mpEthAmount = IStaking(mpeth).depositETH{value: msg.value}(address(this));

        // project fees
        uint256 chargedFees = _chargeFee(mpEthAmount);
        uint256 valueAfterFees = mpEthAmount - chargedFees;

        // send tokens to the bridge
        IERC20(mpeth).safeIncreaseAllowance(bridge, valueAfterFees);
        ITokenBridge(bridge).bridgeToken(mpeth, valueAfterFees, msg.sender);

        emit NewSwapToMpEthOnLinea(msg.sender, valueAfterFees);
    }
}
