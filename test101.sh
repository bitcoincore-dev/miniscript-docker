#!/usr/bin/env bash
#fail
echo "and_b(after(1),a:after(1000000000))" | ./miniscript | jq || true
#echo "or_i(and_b(after(1),a:after(1000000000)),pk(03cdabb7f2dce7bfbd8a0b9570c6fd1e712e5d64045e9d6b517b3d5072251dc204)" | ./miniscript | jq || true
