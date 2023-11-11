#!/usr/bin/env bash
## echo "or_i(and_v(v:thresh(2,pkh(M1),a:pkh(M2),a:pkh(M3)),after(1005)),and_v(v:thresh(2,pk(P1),s:pk(P2),s:pk(P3),sun:after(1002),sun:after(1003)),and_v(or_c(pk(SA1),or_c(pk(SA3),v:pkh(SA2))),thresh(2,pk(A1),s:pk(A2),s:pk(A3),sln:after(1004)))))" | ./miniscript | jq



#echo "thresh(3,pk(key_1),pk(key_2),pk(key_3),older(12960))" | ./miniscript | jq

FIRST=<(echo "thresh(3,pk(key_1),pk(key_2),pk(key_3),older(12960))" | ./miniscript)

echo $FIRST;

echo "thresh(3,pk(key_1),s:pk(key_2),s:pk(key_3),sln:older(12960))" | ./miniscript | jq
