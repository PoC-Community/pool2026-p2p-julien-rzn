// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vault {
    IERC20 public immutable asset;
    uint256 public totalShares;
    mapping(address => uint256) public sharesOf;
    constructor(address _asset) {
        asset = IERC20(_asset);
    }
    function _convertToShares(uint256 assets) internal view returns (uint256) {
        if (totalShares == 0) {
            return assets;
        }
        uint256 totalAssets = asset.balanceOf(address(this));
        uint256 shares = (assets * totalShares) / totalAssets;
        return shares;
    }
    function _convertToAssets (uint256 shares) internal view returns (uint256) {
        if (totalShares == 0) {
            return 0;
        }
        uint256 totalAssets = asset.balanceOf(address(this));
        uint256 assets = (shares * totalAssets) / totalShares;
        return assets;
    }
}
