#!/usr/bin/env bash
for i in {0..9}; do
    echo $i
    [  $i -gt 0 ] && echo "thresh(2,ltv:after($i),altv:after(1$i),a:pk(0))" | miniscript
    for j in {0..9}; do
        echo $i $j
        [  $i -gt 0 ] && [ $j -gt 0 ] && echo "thresh(2,ltv:after($i$j),altv:after(1$i$j),a:pk(0))" | miniscript
        for k in {0..9}; do
            echo $i $j $k
            echo "thresh(2,ltv:after(1$i$j$k$i$j$k$i$j$k),altv:after($j$k),a:pk(0))" | miniscript
        done
    done
done
echo "thresh(2,ltv:after(1000000000),altv:after(100),a:pk(0))" | miniscript
