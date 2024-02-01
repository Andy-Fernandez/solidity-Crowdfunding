// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
### Reto 1 - Crowdfunding

- Crea un contrato y agrega variables de estado.
- Crea una función fundProject que permita enviar ether a un proyecto.
- Crea una función changeProjectState que permita cambiar el estado de un proyecto.

*/
contract Crowfonding {
    

    struct Proyecto {
        bool disponibilidad;
        uint fondosRecibidos;
    }

    mapping(address => Proyecto) proyectos;

    function fundProject(address _proyectAdress) public payable{
        Proyecto storage proyecto = proyectos[_proyectAdress];
        require(proyecto.disponibilidad, "El proyecto ya no recibe fondos");
        proyecto.fondosRecibidos += msg.value; 
    }



    function changeProjectState(bool _nuevoEstado, address _proyectAdress) public {
        Proyecto storage proyecto = proyectos[_proyectAdress];
        proyecto.disponibilidad = _nuevoEstado;
    }
}