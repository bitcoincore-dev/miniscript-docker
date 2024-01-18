#!/usr/bin/env bash
for i in {1..999999}; do
    #echo $i
    echo "thresh(2,pk(PUBKEY0),pk(PUBKEY1),after($i))" | miniscript
    for j in {0..9}; do
        #echo $j
        echo "thresh(3,pk(PUBKEY0),pk(PUBKEY1),pk(PUBKEY2),after($i$j))" | miniscript
        for k in {0..9}; do
            #echo $k
            echo "thresh(4,pk(PUBKEY0),pk(PUBKEY1),pk(PUBKEY2),pk(PUBKEY3),after($i$j$k))" | miniscript.json
            echo "thresh(4,pk(PUBKEY0),pk(PUBKEY1),pk(PUBKEY2),pk(PUBKEY3),older($i$j$k))" | miniscript.json
            ##echo "thresh(2,after(1$i$j$k),after($i$j),pk(PUBKEY0))" | miniscript
        done
    done
done


echo "thresh(2,ltv:after(1000000000),altv:after(100),a:pk(PUBKEY0))" | ./miniscript
