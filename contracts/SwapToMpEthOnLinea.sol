// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

// import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IStaking} from "./interfaces/IStaking.sol";
import {ITokenBridge} from "./interfaces/ITokenBridge.sol";

contract SwapToMpEthOnLinea is Initializable {
    uint256 public constant CHAIN_ID = 59144;
    address public constant BRIDGE = 0x051F1D88f0aF5763fB888eC4378b4D8B29ea3319;
    address public constant MPETH = 0x48AFbBd342F64EF8a9Ab1C143719b63C2AD81710;
    // address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address constant SERVICE_FEE = 0x24D9664Ba8384D94499d6698ab285b69E879D971; /// UPDATE THIS ADDRESS!!!
    uint256 constant COMPLEXITY = 2;
    uint256 constant BASE_FEE = 1000;

    error LessThanMinValue();
    error UnsuccessfulApproval();

    // uint256 public decimal1;
    // uint256 public decimal2;
    // uint256 public percent1;
    // uint256 public percent2;
    // address public l2Recepient;
    // uint256[50] private _gap;

    // function initialize(address _l2Recepient) public initializer {
    //     __Ownable_init();
    //     decimal1 = 16;
    //     decimal2 = 15;
    //     percent1 = 5;
    //     percent2 = 2;
    //     l2Recepient = _l2Recepient;
    // }

    // function withdrawTokens(
    //     address token,
    //     address to,
    //     uint256 amount
    // ) external onlyOwner {
    //     if (token == address(0)) {
    //         payable(to).transfer(amount);
    //     } else {
    //         IERC20(token).transfer(to, amount);
    //     }
    // }

    // function setL2Recepient(address _l2Recepient) external onlyOwner {
    //     l2Recepient = _l2Recepient;
    // }

    // function changeConfig(
    //     uint256 newDec1,
    //     uint256 newDec2,
    //     uint256 newPercent1,
    //     uint256 newPercent2
    // ) public onlyOwner {
    //     decimal1 = newDec1;
    //     decimal2 = newDec2;
    //     percent1 = newPercent1;
    //     percent2 = newPercent2;
    // }

    function _chargeFee(uint256 amount) private returns (uint256) {
        uint256 fee = (amount * COMPLEXITY) / BASE_FEE;

        payable(SERVICE_FEE).transfer(fee);
        return fee;
    }

    receive() external payable {
        if (msg.value < 0.01 ether) revert LessThanMinValue();
        // project fees
        uint256 chargedFees = _chargeFee(msg.value);
        uint256 valueAfterFees = msg.value - chargedFees;

        // stake eth -> mpEth
        uint256 mpEthAmount = IStaking(MPETH).depositETH{value: valueAfterFees}(address(this));

        // send tokens to the bridge
        bool success = IStaking(MPETH).approve(BRIDGE, mpEthAmount);
        if (!success) revert UnsuccessfulApproval();
        ITokenBridge(BRIDGE).bridgeToken(MPETH, mpEthAmount, msg.sender);
    }
}
