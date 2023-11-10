#!/usr/bin/env bash
echo "and_b(after(1),a:after(1000000000))" | ./miniscript | jq || true
