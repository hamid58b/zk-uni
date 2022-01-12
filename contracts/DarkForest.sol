//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.11;

import "./verifier.sol";
import "hardhat/console.sol";

contract DarkForest is Verifier {

    struct CellState {
        bool occupied;
        uint256 lastSpawn;
    }

    mapping(address => uint) private playerCell;
    mapping(uint => CellState) worldState;

    event Spawn(address player, uint cell);

    function getPlayerCell(address player) public view returns (bytes memory) {
        return abi.encodePacked(playerCell[player]);
    }

}
