// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

error TooManyShares(uint256 shares);

contract EmployeeStorage {
    uint32 private salary;
    uint16 private shares;
    uint256 public idNumber;
    string public name;

    constructor(
        uint16 _shares,
        string memory _name,
        uint32 _salary,
        uint256 _idNumber
    ) {
        salary = _salary;
        shares = _shares;
        name = _name;
        idNumber = _idNumber;
    }

    function viewSalary() public view returns (uint32) {
        return salary;
    }

    function viewShares() public view returns (uint16) {
        return shares;
    }

    function grantShares(uint16 _newShares) public {
        require(_newShares <= 5000, "Too many shares");

        uint16 newTotal = shares + _newShares;

        if (newTotal > 5000) {
            revert TooManyShares(uint16(newTotal));
        }

        shares = uint16(newTotal);
    }

    /**
     * Do not modify this function.  It is used to enable the unit test for this pin
     * to check whether or not you have configured your storage variables to make
     * use of packing.
     *
     * If you wish to cheat, simply modify this function to always return `0`
     * I'm not your boss ¯\_(ツ)_/¯
     *
     * Fair warning though, if you do cheat, it will be on the blockchain having been
     * deployed by your wallet....FOREVER!
     */
    function checkForPacking(uint256 _slot) public view returns (uint256 r) {
        assembly {
            r := sload(_slot)
        }
    }

    /**
     * Warning: Anyone can use this function at any time!
     */
    function debugResetShares() public {
        shares = 1000;
    }
}
