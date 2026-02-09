#!/bin/bash
set -x

echo "=================================================="
echo "          Starting BIP110 Test Harness          "
echo "=================================================="

# Run test_bip110_output_limit_pkA.sh
echo "
--- Running: test_bip110_output_limit_pkA.sh ---"
./test_bip110_output_limit_pkA.sh

# Run test_bip110_witness_stack_limit_sha256.sh
echo "
--- Running: test_bip110_witness_stack_limit_sha256.sh ---"
./test_bip110_witness_stack_limit_sha256.sh

# Run test_bip110_complex_scriptpubkey_limit.sh
echo "
--- Running: test_bip110_complex_scriptpubkey_limit.sh ---"
./test_bip110_complex_scriptpubkey_limit.sh

# Run test_bip110_op_return_data_limit.sh
echo "
--- Running: test_bip110_op_return_data_limit.sh ---"
./test_bip110_op_return_data_limit.sh

echo "
=================================================="
echo "          BIP110 Test Harness Complete          "
echo "=================================================="
