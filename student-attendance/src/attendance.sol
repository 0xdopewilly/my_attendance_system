// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract Owned {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
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

    mapping(uint256 => Student) studentList;
    uint256[] public studentIdList;

    mapping(address => bool) public authorizedClassReps;

    event studentCreationEvent(
        string fName,
        string lName,
        uint256 age
    );

    event classRepAuthorized(address classRep);
    event classRepRevoked(address classRep);

    modifier onlyAuthorized() {
        require(msg.sender == owner || authorizedClassReps[msg.sender], "Caller is not authorized");
        _;
    }

    function authorizeClassRep(address _classRep) public onlyOwner {
        authorizedClassReps[_classRep] = true;
        emit classRepAuthorized(_classRep);
    }

    function revokeClassRep(address _classRep) public onlyOwner {
        authorizedClassReps[_classRep] = false;
        emit classRepRevoked(_classRep);
    }

    function createStudent(uint _studId, uint _age, string memory _fName, string memory _lName) public onlyAuthorized {
        Student storage student = studentList[_studId];
        
        student.age = _age;
        student.fName = _fName;
        student.lName = _lName;
        student.attendanceValue = 0;
        studentIdList.push(_studId);
        emit studentCreationEvent(_fName, _lName, _age);
    }
    
    function incrementAttendance(uint _studId) public onlyAuthorized {
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
