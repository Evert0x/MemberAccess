# Member access control

An implementation of an member access module (TMP-2)

With the following roles

- member
- manager
- admin

This implementation assigns member ids (uint256) to members with a mapping to an address and vica versa. This allows a members address to be updated during the lifecycle of a pool.

## Implements

- memberid (TMP-2)
- poolroles (TMP-3)

## Depends on

- access-control (TMP-1)

`git submodule update --remote AccessControl`
