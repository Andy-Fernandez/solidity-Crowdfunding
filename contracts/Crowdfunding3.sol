// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
### Challenge #3

• Add events to the fundProject and changeProjectState functions.
• Consider what information will be relevant for the event subscribers.

*/
contract Crowfonding {

    string public id;
    string public name;
    string public description;
    address payable public author;
    string public state;
    uint public funds;
    uint public fundarisingGoal;
    
    constructor(string memory _id, string memory _name, string memory _description, uint _fundarisingGoal){
        id = _id;
        name =_name;
        description = _description;
        author = payable(msg.sender); 
        fundarisingGoal = _fundarisingGoal;
        state = 'Opened';
        funds = 0;
    }

    event FundProject(
        address funder, // another opcion is use idProyect 'couse is relevant for any app 
        uint amount
    );
    
    event ChangeProjectState(
        address editor, // another opcion is use idProyect too
        string newStatus
    );

    modifier onlyOwner () {
        require(
            msg.sender == author, 
            "Only the owner can chenge ther project state"
        );
        _;
    }

    modifier notOwner () {
        require(
            msg.sender != author, 
            "Owners can't fund thir porject"
        );
        _;
    }

    function fundProject() public payable notOwner{
        require(
            keccak256(abi.encodePacked(state)) == keccak256(abi.encodePacked('Opened')), 
            "Project is not able to accept funds"
        );
        author.transfer(msg.value);
        funds += msg.value;
        emit FundProject(msg.sender, msg.value);
    }

    function changeProjectState(string calldata _newState) public onlyOwner{
        state = _newState;
        emit ChangeProjectState(msg.sender, state);
    }
}