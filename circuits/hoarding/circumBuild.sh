#!/bin/bash

circom-execute() {
    nvm use --lts;
    echo -e "Please enter your circom file name (no file extension needed): ";
    read name;
    circom $name.circom --r1cs --wasm --sym --c;
    cd $(echo $name | tr -d '\r')_js;
    nvm use --lts;
    touch input.json;
    echo -e "Enter your input signals in the input.json file. Press C and hit Enter to continue..."
    read REPLY
    if [[ $REPLY =~ ^[Cc]$ ]]
    then
      cd ./init_js
      node generate_witness.js $name.wasm input.json witness.wtns;
      snarkjs powersoftau new bn128 12 pot12_0000.ptau -v;
      snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v;
      snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v;
      snarkjs groth16 setup ../$name.r1cs pot12_final.ptau $name_0000.zkey;
      snarkjs zkey contribute $name_0000.zkey $name_0001.zkey --name="1st Contributor Name" -v;
      snarkjs zkey export verificationkey $name_0001.zkey verification_key.json;
      snarkjs groth16 prove $name_0001.zkey witness.wtns proof.json public.json;
      snarkjs groth16 verify verification_key.json public.json proof.json;
    fi
} 

circom-execute