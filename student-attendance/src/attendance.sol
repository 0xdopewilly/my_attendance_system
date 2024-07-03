//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract Owned {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }
}

contract Attendance is Owned {

    struct Student {
        uint256 age;
        string fName;
        string lName;
        uint256 attendanceValue;
    }

    mapping (uint256 => Student) studentList;
    uint256[] public studentIdList;

    event studentCreationEvent(
        string fName,
        string lName,
        uint256 age
    );

    function createStudent(uint _studId, uint _age, string memory _fName, string memory _lName) onlyOwner public {
        Student storage student = studentList[_studId];
        
        student.age = _age;
        student.fName = _fName;
        student.lName = _lName;
        student.attendanceValue = 0;
        studentIdList.push(_studId);
        emit studentCreationEvent(_fName, _lName, _age);
    }
    
    function incrementAttendance(uint _studId) onlyOwner public {
        studentList[_studId].attendanceValue = studentList[_studId].attendanceValue + 1;
    }
    
    function getStudents() view public returns(uint256[] memory) {
        return studentIdList;
    }
    
    function getParticularStudent(uint _studId) public view returns (string memory, string memory, uint256, uint256) {
        Student storage student = studentList[_studId];
        return (student.fName, student.lName, student.age, student.attendanceValue);
    }

    function countStudents() view public returns (uint256) {
        return studentIdList.length;
    }
}
