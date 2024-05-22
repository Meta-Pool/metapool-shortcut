// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {IStaking} from "./interfaces/IStaking.sol";
import {ITokenBridge} from "./interfaces/ITokenBridge.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/// @title Meta Pool Shorcut -> Swap mainnet ETH for mpETH on Linea (L2)

contract SwapToMpEthOnLineaV1 is Initializable, OwnableUpgradeable {
    using SafeERC20 for IERC20;

    /// @dev Linea bridge address
    address public bridge;
    address public mpeth;

    uint256 public constant COMPLEXITY = 2;
    uint256 public constant BASE_FEE = 1000;

    error InvalidAddress();
    error LessThanMinValue();
    error UnsuccessfulApproval();

    event NewSwapToMpEthOnLinea(address indexed _receiver, uint256 _amount);

    constructor() { _disableInitializers(); }

    function initialize(
        address _bridge,
        address _mpeth,
        address _owner
    ) public initializer {
        if (_mpeth == address(0)
            || _bridge == address(0)
            || _owner == address(0)) revert InvalidAddress();
        bridge = _bridge;
        mpeth = _mpeth;
        __Ownable_init(_owner);
    }

    function updateBridgeAddress(address _bridge) external onlyOwner returns (bool) {
        if (_bridge == address(0) || _bridge == bridge) revert InvalidAddress();
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
