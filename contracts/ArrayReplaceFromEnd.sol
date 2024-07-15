// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ArrayReplaceFromEnd{
    uint256[] public arr;

    function remove(uint256 index) public {
        arr[index] = arr[arr.length - 1];
        // Remove the last element
        arr.pop();
    }

    function test() public {
        arr = [1,2,3,4];
        remove(1);
    }

}