// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HaikuNFT is ERC721 {
    using Counters for Counters.Counter;

    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    error HaikuNotUnique();
    error NotYourHaiku(uint256 haikuId);
    error NoHaikusShared();

    mapping(string => bool) private usedLines;

    Haiku[] public haikus;

    mapping(address => uint256[]) public sharedHaikus;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("HaikuNFT", "HAIKU") {
        haikus.push(Haiku(address(0), "", "", ""));
        _tokenIdCounter.increment();
    }

    function mintHaiku(
        string calldata line1,
        string calldata line2,
        string calldata line3
    ) external {
        if (usedLines[line1] || usedLines[line2] || usedLines[line3]) {
            revert HaikuNotUnique();
        }

        usedLines[line1] = true;
        usedLines[line2] = true;
        usedLines[line3] = true;

        uint256 haikuId = _tokenIdCounter.current();
        _safeMint(msg.sender, haikuId);

        haikus.push(Haiku(msg.sender, line1, line2, line3));

        _tokenIdCounter.increment();
    }

    function shareHaiku(uint256 haikuId, address to) public {
        if (ownerOf(haikuId) != msg.sender) {
            revert NotYourHaiku(haikuId);
        }

        sharedHaikus[to].push(haikuId);
    }

    function getMySharedHaikus() public view returns (Haiku[] memory) {
        uint256[] memory ids = sharedHaikus[msg.sender];
        uint256 len = ids.length;

        if (len == 0) {
            revert NoHaikusShared();
        }

        Haiku[] memory result = new Haiku[](len);
        for (uint256 i = 0; i < len; i++) {
            result[i] = haikus[ids[i]];
        }

        return result;
    }

    function totalHaikusMinted() public view returns (uint256) {
        return _tokenIdCounter.current() - 1;
    }

    function counter() external view returns (uint256) {
        return _tokenIdCounter.current();
    }
}
