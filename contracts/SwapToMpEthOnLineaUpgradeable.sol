// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Initializable} from "";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IStaking} from "./interfaces/IStaking.sol";
import {ITokenBridge} from "./interfaces/ITokenBridge.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SwapToMpEthOnLineaUpgradeable is Ownable, Initializable {
    using SafeERC20 for IERC20;

    uint256 public immutable chainId; /// Linea Mainnet 59144
    address public immutable bridge; /// 0x051F1D88f0aF5763fB888eC4378b4D8B29ea3319
    address public immutable mpETH; /// 0x48AFbBd342F64EF8a9Ab1C143719b63C2AD81710

    uint256 public immutable COMPLEXITY = 2;
    uint256 public immutable BASE_FEE = 1000;

    error LessThanMinValue();
    error UnsuccessfulApproval();

    event NewSwapToMpEthOnLinea(address indexed _receiver, uint256 _amount);

    /// @param _chainId eip-1344 Chain ID is a 256-bit value
    function constructor(
        uint256 _chainId,
        address _bridge,
        address _mpeth,
        address _owner /// 0xf1552d1d7CD279A7B766F431c5FaC49A2fb6e361
    ) Ownable(_owner) {
        chainId = _chainId;
        bridge = _bridge;
        mpeth = _mpeth;
    }

    /// @notice the owner receives the fee.
    function _chargeFee(uint256 amount) private returns (uint256) {
        if (owner() == address(0)) {
            return 0;
        } else {
            // owner() != address(0)
            uint256 fee = (amount * COMPLEXITY) / BASE_FEE;
            IERC20(MPETH).safeTransfer(owner(), fee);
            return fee;
        }
    }

    receive() external payable {
        if (msg.value < 0.01 ether) revert LessThanMinValue();

        // stake eth -> mpEth
        uint256 mpEthAmount = IStaking(MPETH).depositETH{value: msg.value}(address(this));

        // project fees
        uint256 chargedFees = _chargeFee(mpEthAmount);
        uint256 valueAfterFees = mpEthAmount - chargedFees;

        // send tokens to the bridge
        IERC20(MPETH).safeIncreaseAllowance(BRIDGE, valueAfterFees);
        ITokenBridge(BRIDGE).bridgeToken(MPETH, valueAfterFees, msg.sender);

        emit NewSwapToMpEthOnLinea(msg.sender, valueAfterFees);
    }
}
