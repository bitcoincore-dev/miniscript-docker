#!/usr/bin/env bash
echo "thresh(3,c:pk_k(0),sc:pk_k(1),sc:pk_k(2),sdv:older(3))" | ./miniscript | jq || true
