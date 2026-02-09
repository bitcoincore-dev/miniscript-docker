#!/bin/bash

echo "--- Testing BIP110 34-byte Transaction Output Limit Violation (pk(A)) ---"

echo "Miniscript Policy: pk(A)"

echo "Explanation of Violation:"
echo "1. BIP110 Rule: Transaction outputs (value + scriptPubKey) must not exceed 34 bytes."
echo "   - An 8-byte value field leaves only 26 bytes for the scriptPubKey."
echo "2. pk(A) Compilation: The Miniscript 'pk(A)' for a compressed public key compiles to a scriptPubKey of approximately 35 bytes (33-byte public key + OP_CHECKSIG + push opcode)."
echo "3. Calculated Output Size: 8 bytes (value) + 35 bytes (scriptPubKey) = 43 bytes."
echo "4. Violation: 43 bytes > 34 bytes. Therefore, any transaction using this output would be invalid under BIP110."

echo "This script demonstrates the policy. To actually see the compiled script, you would typically use the Miniscript web compiler."
