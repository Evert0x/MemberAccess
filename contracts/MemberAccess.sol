// contracts/AssetPool.sol
// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.7.4;

import "../TMP1/contracts/AccessControl.sol";
import "diamond-2/contracts/libraries/LibDiamond.sol";
import "./interfaces/IMemberID.sol";
import "./interfaces/IPoolRoles.sol";
import "./storage/LibMemberAccessStorage.sol";
import "./PoolRolesView.sol";

contract MemberAccess is IMemberID, IPoolRoles, AccessControl, PoolRolesView {
    function initializeRoles(address _owner) public override {
        LibMemberAccessStorage.memberStorage().memberCounter = 1000;
        setupMember(_owner);
        _setupRole(DEFAULT_ADMIN_ROLE, _owner);
        _setupRole(MEMBER_ROLE, _owner);
        _setupRole(MANAGER_ROLE, _owner);
    }

    function isMember(address _account) external override view returns (bool) {
        return _isMember(_account);
    }

    function addMember(address _account) external override {
        setupMember(_account);
        _grantRole(MEMBER_ROLE, _account);
    }

    function removeMember(address _account) external override {
        _revokeRole(MEMBER_ROLE, _account);
    }

    function isManager(address _account) external override view returns (bool) {
        return _isManager(_account);
    }

    function addManager(address _account) external override {
        setupMember(_account);
        _grantRole(MANAGER_ROLE, _account);
    }

    function removeManager(address _account) external override {
        require(_msgSender() != _account, "OWN_ACCOUNT");
        _revokeRole(MANAGER_ROLE, _account);
    }

    function isManagerRoleAdmin(address _account)
        external
        override
        view
        returns (bool)
    {
        return _hasRole(getRoleAdmin(MANAGER_ROLE), _account);
    }

    function isMemberRoleAdmin(address _account)
        external
        override
        view
        returns (bool)
    {
        return _hasRole(getRoleAdmin(MEMBER_ROLE), _account);
    }

    function getOwner() external override view returns (address) {
        return _getOwner();
    }

    function upgradeAddress(address _oldAddress, address _newAddress)
        external
        override
    {
        require(_oldAddress == _msgSender(), "OLD_NOT_SENDER");
        LibMemberAccessStorage.MemberStorage storage ms = LibMemberAccessStorage
            .memberStorage();
        uint256 member = ms.addressToMember[_oldAddress];
        require(member != 0, "NON_MEMBER");
        ms.addressToMember[_oldAddress] = 0;
        ms.addressToMember[_newAddress] = member;
        ms.memberToAddress[member] = _newAddress;

        if (_hasRole(MEMBER_ROLE, _oldAddress)) {
            _revokeRole(MEMBER_ROLE, _oldAddress);
            _grantRole(MEMBER_ROLE, _newAddress);
        }

        if (_hasRole(MANAGER_ROLE, _oldAddress)) {
            _revokeRole(MANAGER_ROLE, _oldAddress);
            _grantRole(MANAGER_ROLE, _newAddress);
        }
        emit MemberAddressChanged(member, _oldAddress, _newAddress);
    }

    function getAddressByMember(uint256 _member)
        external
        override
        view
        returns (address)
    {
        return LibMemberAccessStorage.memberStorage().memberToAddress[_member];
    }

    function getMemberByAddress(address _address)
        external
        override
        view
        returns (uint256)
    {
        return LibMemberAccessStorage.memberStorage().addressToMember[_address];
    }

    function setupMember(address _account) internal {
        LibMemberAccessStorage.MemberStorage storage ms = LibMemberAccessStorage
            .memberStorage();
        uint256 member = ms.addressToMember[_account];
        if (member != 0) {
            //member is already setup
            return;
        }
        ms.memberCounter += 1;
        ms.addressToMember[_account] = ms.memberCounter;
        ms.memberToAddress[ms.memberCounter] = _account;
    }
}
