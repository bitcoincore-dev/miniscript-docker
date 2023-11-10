#!/usr/bin/env bash
#
TESTS=$(echo test{0..1000}.sh)
for ms in $TESTS
do
    . $ms 2>/dev/null
done
