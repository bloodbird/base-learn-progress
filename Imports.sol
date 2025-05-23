// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
 
library SillyStringUtils {
    struct Haiku {
        string line1;
        string line2;
        string line3;
    }
 
    function shruggie(string memory _input) internal pure returns (string memory) {
        return string.concat(_input, unicode" 🤷");
    }
}

contract ImportsExercise {
    using SillyStringUtils for SillyStringUtils.Haiku;

    SillyStringUtils.Haiku private haiku;

    function saveHaiku(
        string memory _line1,
        string memory _line2,
        string memory _line3
    ) public {
        haiku = SillyStringUtils.Haiku(_line1, _line2, _line3);
    }

    function getHaiku() public view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    function shruggieHaiku() public view returns (SillyStringUtils.Haiku memory) {
        return SillyStringUtils.Haiku(
            haiku.line1,
            haiku.line2,
            SillyStringUtils.shruggie(haiku.line3)
        );
    }
}
