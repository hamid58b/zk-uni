//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.11;

import "./verifier.sol";
import "hardhat/console.sol";

contract DarkForest is Verifier {

  
    struct Planet {
        address owner;
        uint planetType;
        uint pendingResources;
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

    
    constructor(){}

    



}
