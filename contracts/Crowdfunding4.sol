// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
Challenge #4
• Create a validation to prevent contributing to the project if the state is 'Closed'.
• Implement a validation to disallow updating a state; it must be different from the current one.
• Develop a validation to prohibit contributions with a zero value.
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
        address funder,
        uint amount
    );
    
    event ChangeProjectState(
        address editor,
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

    error StateClosed(string stateClosed);

    function fundProject() public payable notOwner{
        /*require(
            keccak256(abi.encodePacked(state)) == keccak256(abi.encodePacked('Opened')), 
            "Project is not able to accept funds"
        );*/

        if (keccak256(abi.encodePacked(state)) == keccak256(abi.encodePacked('Closed'))) {
            revert StateClosed(state);
        }

        if (msg.value == 0) {
            revert ("The contribution must have a value greater than zero.");
        }

        if (fundarisingGoal < (msg.value + funds)){
            revert ("The fundraising goal is not exceeded");
        }

        author.transfer(msg.value);
        funds += msg.value;
        emit FundProject(msg.sender, msg.value);
    }

    error StateNotDefined(string newState);

    function changeProjectState(string calldata _newState) public onlyOwner{
        if (keccak256(abi.encodePacked(_newState)) == keccak256(abi.encodePacked('Opened')) ||
            keccak256(abi.encodePacked(_newState)) == keccak256(abi.encodePacked('Closed'))) {
            if (keccak256(abi.encodePacked(_newState)) != keccak256(abi.encodePacked(state))){
                state = _newState;
                emit ChangeProjectState(msg.sender, state);
            } else {
                revert StateNotDefined(_newState);
            }
        } else {
            revert StateNotDefined(_newState);
        }
        /* Another way to solve 
        if (!(keccak256(abi.encodePacked(_newState)) == keccak256(abi.encodePacked('Opened')) ||
            keccak256(abi.encodePacked(_newState)) == keccak256(abi.encodePacked('Closed')))) {
            revert("StateNotDefined: Invalid state");
        }
        state = _newState;
        emit ChangeProjectState(msg.sender, state);
        */
    }
}