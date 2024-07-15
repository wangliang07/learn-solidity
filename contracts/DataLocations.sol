// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract DataLocations{
    uint256[] public arr;
    mapping(uint256 => address) map;

    struct MyStruct{
        uint foo;
    }

    mapping(uint256 => MyStruct) myStructs;

    function f() public {
        _f(arr, map, myStructs[1]);

        // get a struct from a mapping
        //MyStruct storage myStruct = myStructs[1];
        // create a struct in memory
        //MyStruct memory myMemStruct = MyStruct(0);
    }

    function _f(
        uint256[] storage _arr,
        mapping(uint256 => address) storage _map,
        MyStruct storage _myStruct
    ) internal {
        arr = _arr;
        map[0] = _map[0];
        myStructs[0] = _myStruct;
    }

    function g(uint256[] memory _arr) public returns(uint256[] memory){
        arr = _arr;
        return arr;
    }

    function h(uint256[] calldata _arr) external {
        arr = _arr;
    }
}