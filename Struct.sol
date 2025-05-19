// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

error BadCarIndex(uint index);

contract GarageManager {
    struct Car {
        bytes32 make;
        bytes32 model;
        bytes32 color;
        uint8 numberOfDoors;
    }

    mapping(address => Car[]) public garage;

    function addCar(
        bytes32 make,
        bytes32 model,
        bytes32 color,
        uint8 numberOfDoors
    ) public {
        Car memory newCar = Car({
            make: make,
            model: model,
            color: color,
            numberOfDoors: numberOfDoors
        });

        garage[msg.sender].push(newCar);
    }

    function getMyCars() public view returns (Car[] memory) {
        return garage[msg.sender];
    }

    function getUserCars(address user) public view returns (Car[] memory) {
        return garage[user];
    }

    function updateCar(
        uint index,
        bytes32  make,
        bytes32  model,
        bytes32  color,
        uint8 numberOfDoors
    ) public {
        if (index >= garage[msg.sender].length) {
            revert BadCarIndex(index);
        }

        garage[msg.sender][index] = Car({
            make: make,
            model: model,
            color: color,
            numberOfDoors: numberOfDoors
        });
    }

    function resetMyGarage() public {
        delete garage[msg.sender];
    }
}
