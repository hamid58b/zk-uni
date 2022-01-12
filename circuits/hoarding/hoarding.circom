pragma circom 2.0.0;
include "../../node_modules/circomlib/circuits/mimcsponge.circom";
include "../../node_modules/circomlib/circuits/comparators.circom";

template Main() {
    signal input x;
    signal input y;
    signal input r;

    signal output h;

    signal xSq;
    signal ySq;
    signal rSq;

    r === 64;

    xSq <== x * x;
    ySq <== y * y;
    rSq <== r * r;

    
    /* check MiMCSponge(x,y) = pub */
    component mimc = MiMCSponge(2, 220, 1);

    mimc.ins[0] <== x;
    mimc.ins[1] <== y;
    mimc.k <== 0;

    mimc.outs[0] ==> h;

    for (var i = 0; i < 18; i++) {
      eq[i] = IsEqual();
      // assignment instead of constraint, xor and % break quadratic constraint
      gcd --> eq[i].in[0];
      primes[i] ==> eq[i].in[1];
      sum += eq[i].out;

      // debugging
      if (eq[i].out == 1) {
        log(primes[i]);
      }
    }
    log(sum);

    // We want that sum is zero, i.e gcd isn't equal to any prime.
    component isz = IsZero();
    sum ==> isz.in;
    isz.out === 1;
    // Success code 
    log(200);
}
component main {public [r]} = Main();