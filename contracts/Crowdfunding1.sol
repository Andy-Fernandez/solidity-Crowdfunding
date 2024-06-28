// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
### Reto 1 - Crowdfunding

- Crea un contrato y agrega variables de estado.
- Crea una función fundProject que permita enviar ether a un proyecto.
- Crea una función changeProjectState que permita cambiar el estado de un proyecto.

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

    function fundProject() public payable{
        require(keccak256(abi.encodePacked(state)) == keccak256(abi.encodePacked('Opened')), "Project is not able to accept funds");
        author.transfer(msg.value);
        funds += msg.value; 
    }

    function changeProjectState(string calldata _newState) public {
        state = _newState;
    }
}
