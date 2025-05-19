// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

contract ArrayDemo {
    uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];
    uint8 numEven = 5;
    address[] private senders;
    uint[] private timestamps; 

    function getEvenNumbers() external view returns (uint256[] memory) {
        uint256 countEvenNumbers = numEven;
        uint256[] memory results = new uint256[](countEvenNumbers);
        uint256 cursor = 0;

        for (uint256 i = 0; i < numbers.length; i++) {
            if (numbers[i] % 2 == 0) {
                results[cursor] = numbers[i];
                cursor++;
            }
        }

        return results;
    }

    function _countEvenNumbers() internal view returns (uint256) {
        uint256 result = 0;

        for (uint256 i = 0; i < numbers.length; i++) {
            if (numbers[i] % 2 == 0) {
                result++;
            }
        }

        return result;
    }

    function debugLoadArray(uint256 _number) public {
        for (uint256 i = 0; i < _number; i++) {
            numbers.push(i);

            if(_number % 2 == 0) {
                numEven++;
            }
        }
    }

    function getNumbers() public view returns (uint256[] memory) {
        return numbers;
    }

    function resetNumbers() public {
        numbers = [1,2,3,4,5,6,7,8,9,10];
    }

    function appendToNumbers(uint[] calldata _toAppend) public {
        numbers = _toAppend;
    }
    
    function saveTimestamp(uint _unixTimestamp) public {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    function afterY2K() public view returns (uint[] memory recentTimestamps, address[] memory recentSenders){
        for(uint i = 0; i < timestamps.length; i++) {
            if(timestamps[i] > 946702800) {
                recentTimestamps.push(timestamps[i]);
                recentSenders.push(senders[i]);
            }
        }
    }

    function resetSenders() public {
        senders = [];
    }

    function resetTimestamps () public {
        timestamps = [];
    }
}
