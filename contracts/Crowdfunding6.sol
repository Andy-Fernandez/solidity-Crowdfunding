// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
Challenge #6
• Add the project states to an Enum to prevent the creation of new states.
*/

contract Crowdfunding {

    enum State {Closed, Opened}

    struct Project {
        string id;
        string name;
        string description;
        address payable author;
        uint fundraisingGoal;
        State state;
        uint funds;
    }

    Project public project;

    
    constructor(string memory _id, string memory _name, string memory _description, uint _fundraisingGoal) {
        project = Project(_id, _name, _description, payable(msg.sender), _fundraisingGoal, State.Opened, 0);
    }

    event FundProject(
        address funder,
        uint amount
    );
    
    event ChangeProjectState(
        address editor,
        State newState
    );

    modifier onlyOwner () {
        require(
            msg.sender == project.author, 
            "Only the owner can change the project state"
        );
        _;
    }

    modifier notOwner () {
        require(
            msg.sender != project.author, 
            "Owners can't fund their project"
        );
        _;
    }

    function fundProject() public payable notOwner {
        require(
            keccak256(abi.encodePacked(project.state)) != keccak256(abi.encodePacked('Closed')), 
            "StateClosed: Project is closed"
        );

        require(
            msg.value > 0, 
            "The contribution must have a value greater than zero"
        );

        require(
            project.fundraisingGoal >= (msg.value + project.funds),
            "The fundraising goal is exceeded"
        );

        project.author.transfer(msg.value);
        project.funds += msg.value;
        emit FundProject(msg.sender, msg.value);
    }

    error StateNotDefined(string newState);

    function changeProjectState(State _newState) public onlyOwner {
        require(
            _newState == State.Opened || _newState == State.Closed,
            "StateNotDefined: Invalid state"
        );

        require(
            keccak256(abi.encodePacked(_newState)) != keccak256(abi.encodePacked(project.state)),
            "StateNotDefined: New state must be different from the current one"
        );

        project.state = _newState;
        emit ChangeProjectState(msg.sender, project.state);
    }
}
