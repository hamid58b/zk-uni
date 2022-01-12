pragma circom 2.0.0;

//include "../../node_modules/circomlib/circuits/mimcsponge.circom";
//include "../../node_modules/circomlib/circuits/comparators.circom";

/*
Constraints:

-  [0, R(T)] (so they use that to confuse other players).
- Collect resources up to R(T)

- Resource collection is considered final only when a player leaves the planet.

- If a player P2 moves to a planet (1,1) that another player P1 is occupying, then all pending resources that P1 started collecting since their arrival will be transferred as pending for P2. 

- constrain maximum movement distance to 16

*/

template Main() {
    
    //previous location
    signal input x;
    signal input y;
    
    //new location
    signal input new_x;
    signal input new_y;
    
    //constrain maximum movement distance from prev location to new location to 16 (d = 16)
    signal input d;
    

    /* check MiMCSponge(x,y) = pub */
    component mimc = MiMCSponge(2, 220, 1);

    mimc.ins[0] <== x;
    mimc.ins[1] <== y;
    mimc.k <== 0;

    h <== mimc.outs[0];

    //check if max move distance is 16
    signal xSq;
    signal ySq;
    signal dSq;
    
    signal dif_x;
    signal dif_y;

    dSq <== d * d; //distance
    
    dif_x <== new_x - x;
    xSq <== dif_x * dif_x;
    
    dif_y <== new_y - y;
    ySq <== dif_y * dif_y;
    
    less.in[0] <== xSq + ySq;
    less.in[1] <== dSq;
    
    less.out === 1;

    //check if the distance from (0,0) is less than 128
    //TODO

    
}


component main {public [d]} = Main();