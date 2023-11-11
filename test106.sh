#!/usr/bin/env bash
for i in {0..100}; do
    echo $i
echo "thresh(2,c:pk_k(0),sc:pk_k(2),sdv:older($i))" | ./miniscript | jq || true
done
for i in {0..100}; do
    echo $i
echo "thresh(3,c:pk_k(0),sc:pk_k(1),sc:pk_k(2),sdv:older($i))" | ./miniscript | jq || true
done
for i in {0..100}; do
    echo $i
echo "thresh(4,c:pk_k(0),sc:pk_k(1),sc:pk_k(2),sc:pk_k(3),sdv:older($i))" | ./miniscript | jq || true
done
