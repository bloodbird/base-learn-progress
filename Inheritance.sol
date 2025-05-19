// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

/// @title Inheritance Exercise

abstract contract Employee {
    uint public idNumber;
    uint public managerId;

    constructor(uint _idNumber, uint _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    function getAnnualCost() public view virtual returns (uint);
}

contract Salaried is Employee {
    uint public annualSalary;

    constructor(uint _idNumber, uint _managerId, uint _annualSalary)
        Employee(_idNumber, _managerId)
    {
        annualSalary = _annualSalary;
    }

    function getAnnualCost() public view override returns (uint) {
        return annualSalary;
    }
}

contract Hourly is Employee {
    uint public hourlyRate;

    constructor(uint _idNumber, uint _managerId, uint _hourlyRate)
        Employee(_idNumber, _managerId)
    {
        hourlyRate = _hourlyRate;
    }

    function getAnnualCost() public view override returns (uint) {
        return hourlyRate * 2080;
    }
}

contract Manager {
    uint[] public reportIds;

    function addReport(uint id) public {
        reportIds.push(id);
    }

    function resetReports() public {
        delete reportIds;
    }

    function getReports() public view returns (uint[] memory) {
        return reportIds;
    }
}

contract Salesperson is Hourly {
    constructor() Hourly(55555, 12345, 20) {}
}

contract EngineeringManager is Salaried, Manager {
    constructor() Salaried(54321, 11111, 200000) {}
}
