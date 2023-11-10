#!/usr/bin/env bash
echo "or(99@thresh(2,thresh(2,pk(A1),pk(A2),pk(A3),after(1004)),or(10@thresh(2,pk(P1),pk(P2),pk(P3),after(1002)),and(thresh(1,pk(SA1),pk(SA2),pk(SA3)),after(1003)))),and(thresh(2,pk(M1),pk(M2),pk(M3)),after(1005)))" | ./miniscript | jq || true
