// contracts/AssetPool.sol
// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.7.4;

import "../TMP1/contracts/AccessControl.sol";
import "diamond-2/contracts/libraries/LibDiamond.sol";
import "./interfaces/IMemberID.sol";
import "./interfaces/IPoolRoles.sol";
import "./storage/LibMemberAccessStorage.sol";

contract PoolRolesView is  AccessControl {
    bytes32 internal constant DEFAULT_ADMIN_ROLE = 0x00;
    bytes32 internal constant MEMBER_ROLE = keccak256("MEMBER_ROLE");
    bytes32 internal constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    function _isManager(address _account) internal view returns (bool) {
        return _hasRole(MANAGER_ROLE, _account);
    }

    function _isMember(address _account) internal view returns (bool) {
        return
            _hasRole(MEMBER_ROLE, _account) || _hasRole(MANAGER_ROLE, _account);
    }

    function _getOwner() internal view returns (address) {
        return LibDiamond.contractOwner();
    }
}
