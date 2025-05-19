// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract FavoriteRecords {
    mapping(string => bool) public approvedRecords;
    mapping(address => mapping(string => bool)) private userFavorites;
    mapping(address => string[]) private userFavoriteList;
    string[] private approvedRecordList;

    error NotApproved(string album);

    constructor() {
        string[9] memory initialRecords = [
            "Thriller",
            "Back in Black",
            "The Bodyguard",
            "The Dark Side of the Moon",
            "Their Greatest Hits (1971-1975)",
            "Hotel California",
            "Come On Over",
            "Rumours",
            "Saturday Night Fever"
        ];

        for (uint256 i = 0; i < initialRecords.length; i++) {
            approvedRecords[initialRecords[i]] = true;
            approvedRecordList.push(initialRecords[i]);
        }
    }

    function getApprovedRecords() public view returns (string[] memory) {
        return approvedRecordList;
    }

    function addRecord(string memory album) public {
        if (!approvedRecords[album]) {
            revert NotApproved(album);
        }

        if (!userFavorites[msg.sender][album]) {
            userFavorites[msg.sender][album] = true;
            userFavoriteList[msg.sender].push(album);
        }
    }

    function getUserFavorites(address user)
        public
        view
        returns (string[] memory)
    {
        return userFavoriteList[user];
    }

    function resetUserFavorites() public {
        string[] storage favorites = userFavoriteList[msg.sender];

        for (uint256 i = 0; i < favorites.length; i++) {
            userFavorites[msg.sender][favorites[i]] = false;
        }

        delete userFavoriteList[msg.sender];
    }
}
