#!/bin/bash
set -x

echo "--- Testing BIP110 34-byte ScriptPubKey Limit Violation (and(pk(A),pk(B))) ---"

MINISCRIPT_POLICY="and(pk(A),pk(B))"
echo "Miniscript Policy: '${MINISCRIPT_POLICY}'"

cat << EOF
Explanation of Violation (Technical 'Confiscation'):
1. BIP110 Rule: Non-OP_RETURN transaction outputs (value + scriptPubKey) must not exceed 34 bytes.
   - This implies a maximum of 26 bytes for the scriptPubKey (given an 8-byte value field).
2. Compilation of and(pk(A),pk(B)):
   - A single pk(KEY) typically compiles to ~35 bytes (33-byte public key + OP_CHECKSIG + push opcode).
   - The 'and' combinator adds further opcodes (e.g., OP_BOOLAND).
   - The combined scriptPubKey for 'and(pk(A),pk(B))' would be significantly larger than 35 bytes (e.g., 35 + 35 + 1 for OP_BOOLAND, plus other overhead, easily exceeding 70 bytes).
3. Calculated Output Size: Even with minimal overhead, a scriptPubKey this large (e.g., >70 bytes) plus the 8-byte value field would result in a total output size well over 34 bytes.
4. Violation: This scriptPubKey size > 26 bytes. Therefore, any transaction attempting to create an output with this '${MINISCRIPT_POLICY}' Miniscript as its scriptPubKey would be deemed invalid by a BIP110-enforcing node.
5. Implication ('Confiscation'): Funds locked in a UTXO with such a scriptPubKey (if created on a pre-BIP110 chain) would become unspendable on a BIP110-enforcing chain. Similarly, new transactions with such complex scriptPubKeys could not be created or confirmed on a BIP110 chain, effectively 'confiscating' the ability to use such spending conditions.

This script demonstrates the policy. The exact compiled script size would be determined by the Miniscript compiler, but it would undeniably exceed the 34-byte limit.
EOF
