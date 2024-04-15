// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

interface IAcross {
    /// [https://github.com/across-protocol/contracts-v2/blob/master/contracts/SpokePool.sol]
    /// @param depositor The account credited with the deposit who can request to "speed up" this deposit by modifying
    /// the output amount, recipient, and message.
    /// @param recipient The account receiving funds on the destination chain. Can be an EOA or a contract. If
    /// the output token is the wrapped native token for the chain, then the recipient will receive native token if
    /// an EOA or wrapped native token if a contract.
    /// @param inputToken The token pulled from the caller's account and locked into this contract to
    /// initiate the deposit. The equivalent of this token on the relayer's repayment chain of choice will be sent
    /// as a refund. If this is equal to the wrapped native token then the caller can optionally pass in native token as
    /// msg.value, as long as msg.value = inputTokenAmount.
    /// @param outputToken The token that the relayer will send to the recipient on the destination chain. Must be an
    /// ERC20.
    /// @param inputAmount The amount of input tokens to pull from the caller's account and lock into this contract.
    /// This amount will be sent to the relayer on their repayment chain of choice as a refund following an optimistic
    /// challenge window in the HubPool, less a system fee.
    /// @param outputAmount The amount of output tokens that the relayer will send to the recipient on the destination.
    /// @param destinationChainId The destination chain identifier. Must be enabled along with the input token
    /// as a valid deposit route from this spoke pool or this transaction will revert.
    /// @param exclusiveRelayer The relayer that will be exclusively allowed to fill this deposit before the
    /// exclusivity deadline timestamp. This must be a valid, non-zero address if the exclusivity deadline is
    /// greater than the current block.timestamp. If the exclusivity deadline is < currentTime, then this must be
    /// address(0), and vice versa if this is address(0).
    /// @param quoteTimestamp The HubPool timestamp that is used to determine the system fee paid by the depositor.
    /// This must be set to some time between [currentTime - depositQuoteTimeBuffer, currentTime]
    /// where currentTime is block.timestamp on this chain or this transaction will revert.
    /// @param fillDeadline The deadline for the relayer to fill the deposit. After this destination chain timestamp,
    /// the fill will revert on the destination chain. Must be set between [currentTime, currentTime + fillDeadlineBuffer]
    /// where currentTime is block.timestamp on this chain or this transaction will revert.
    /// @param exclusivityDeadline The deadline for the exclusive relayer to fill the deposit. After this
    /// destination chain timestamp, anyone can fill this deposit on the destination chain. If exclusiveRelayer is set
    /// to address(0), then this also must be set to 0, (and vice versa), otherwise this must be set >= current time.
    /// @param message The message to send to the recipient on the destination chain if the recipient is a contract.
    /// If the message is not empty, the recipient contract must implement handleV3AcrossMessage() or the fill will revert.
    function depositV3(
        address depositor,
        address recipient,
        address inputToken,
        address outputToken,
        uint256 inputAmount,
        uint256 outputAmount,
        uint256 destinationChainId,
        address exclusiveRelayer,
        uint32 quoteTimestamp,
        uint32 fillDeadline,
        uint32 exclusivityDeadline,
        bytes calldata message
    ) external payable;

    // Example depositV3(
    //   userAddress, // User's address on the origin chain.
    //   userAddress, // recipient. Whatever address the user wants to recieve the funds on the destination.
    //   usdcAddress, // inputToken. This is the usdc address on the originChain
    //   address(0), // outputToken: 0 address means the output token and input token are the same. Today, no relayers support swapping so the relay will not be filled if this is set to anything other than 0x0.
    //   amount, // inputAmount
    //   amount - totalRelayFee, // outputAmount: this is the amount - relay fees. totalRelayFee is the value returned by the suggested-fees API.
    //   destinationChainId, // destinationChainId
    //   address(0), // exclusiveRelayer: set to 0x0 for typical integrations.
    //   timestamp, // timestamp: this should be the timestamp returned by the API. Otherwise, set to block.timestamp.
    //   block.timestamp + 21600, // fillDeadline: We reccomend a fill deadline of 6 hours out. The contract will reject this if it is beyond 8 hours from now.
    //   0, // exclusivityDeadline: since there's no exclusive relayer, set this to 0.
    //   "", // message: empty message since this is just a simple transfer.
    // );

    // Old function:
    function deposit(
        address recipient,
        address originToken,
        uint256 amount,
        uint256 destinationChainId,
        int64 relayerFeePct,
        uint32 quoteTimestamp,
        bytes memory message,
        uint256 maxCount
    ) external payable;
}
