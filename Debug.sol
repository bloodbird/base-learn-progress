// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

contract ErrorTriageExercise {
    /**
     * Finds the difference between each uint with it's neighbor (a to b, b to c, etc.)
     * and returns a uint array with the absolute integer difference of each pairing.
     */
    function diffWithNeighbor(
        uint _a,
        uint _b,
        uint _c,
        uint _d
    ) public pure returns (int[] memory) {
        int[] memory results = new int[](3);

        results[0] = _a >= _b ? int(_a - _b): int(_b - _a);
        results[1] = _b >= _c ? int(_b - _c) : int(_c - _b);
        results[2] = _c >= _d ? int(_c - _d) : int(_d - _c);

        return results;
    }

    /**
     * Changes the _base by the value of _modifier.  Base is always >= 1000.  Modifiers can be
     * between positive and negative 100;
     */
    function applyModifier(uint256 _base, int256 _modifier)
        public
        pure
        returns (int256)
    {
        return int256(_base) + _modifier;
    }

    /**
     * Pop the last element from the supplied array, and return the popped
     * value (unlike the built-in function)
     */
    uint256[] arr;

    function popWithReturn() public returns (uint256) {
        uint256 index = arr.length - 1;
        uint256 lastValue = arr[index];
        arr.pop();
        return lastValue;
    }

    // The utility functions below are working as expected
    function addToArr(uint256 _num) public {
        arr.push(_num);
    }

    function getArr() public view returns (uint256[] memory) {
        return arr;
    }

    function resetArr() public {
        delete arr;
    }
}
