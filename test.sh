#!/usr/bin/env bash
echo "and(pk(A),or(pk(B),or(9@pk(C),older(1000))))" | ./miniscript;
echo "and_v(or_c(pk(B),or_c(pk(C),v:older(1000))),pk(A))" | ./miniscript
