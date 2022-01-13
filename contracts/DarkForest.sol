// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./verifier.sol";
import "hardhat/console.sol";


contract DarkForest {
    
    struct Planet {
        address owner;
        uint planetType; // 3 types of planets, t1, t2, and t3
        uint pendings; // pending resouces
    }

    //number of resources each player has
    mapping(address => uint) resouces;

    //timestamp for current positions
    mapping(uint => uint) positions;

    //ocuppied positions (True of False)
    mapping(uint => bool) occupied;

    // mapping for players moves
    mapping(address => uint[]) moves;

    //track last move of each player
    mapping(address => uint) recentMove;

    // maps coordinate (X, Y) to a planet
    mapping(uint => Planet) planets;


    function spawn(
            address verifierAddress,
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[3] memory input) public 
    {
        //verify the proof
        bool proof = verifyProof(a, b, c, input);
        require(proof == true, "Proof is not valid!");

        //check if another player is here
        require(occupied[input[0]] == false, "Occupied by another player!");

        //check if Another player here within  5 min
        require(block.timestamp > positions
[input[0]] + 300, "Another player here within  5 min");
        
        
        //spwn, emit message, and then update
        moves[msg.sender].push(input[0]);
        emit Spawned(msg.sender, input[0]);
        positions[input[0]] = block.timestamp;

        //set the flag to occupy the current coordinate
        occupied[input[0]] = true;
    }

    function move(
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[3] memory input,
        
        address verifierAddress,
        uint newLocation,
        uint prevLocation,
        uint planetResouces
    ) public {
        
        //TODO: provide valid proof
        require();

        //not allowed to move to type 0 planet
        require(calculateType(input[0]) != 0, "not allowed to move to type 0 planet");

        //check if moved within last 30 sec
        require(block.timestamp > recentMoves[msg.sender] + 30, "check if moved within last 30 sec");

        //new planet
        Planet memory newPlanet = planets[newLocation];
        
        //set previous location
        Planet memory oldPlanet = planets[prevLocation];

        //TODO: require(planetResouces < newPlanet.planetType, " check for larger resouces withdrawals");
        
        //store the current timestamp for future use
        recentMoves[msg.sender] = block.timestamp;

        // set the current location flag as occupied 
        occupied[newLocation] = true;


    }
}