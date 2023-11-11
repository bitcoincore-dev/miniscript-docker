#!/usr/bin/env bash
for i in {0..10}; do
    echo $i
    echo "thresh(2,c:pk_k(0),sc:pk_k(2),sdv:older($i))" | ./miniscript | jq
    for j in {0..10}; do
        echo $j
        echo "thresh(3,c:pk_k(0),sc:pk_k(1),sc:pk_k(2),sdv:older($j))" | ./miniscript | jq
        for k in {0..10}; do
            echo $k
            echo "thresh(4,c:pk_k(0),sc:pk_k(1),sc:pk_k(2),sc:pk_k(3),sdv:older($i$j$k))" | ./miniscript | jq
            echo "thresh(2,ltv:after(1$i$j$k),altv:after($i$j),a:pk(0))" | ./miniscript | jq
        done
    done
done


echo "thresh(2,ltv:after(1000000000),altv:after(100),a:pk(0))" | ./miniscript
