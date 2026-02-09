#!/bin/bash

echo "--- Testing BIP110 256-byte Witness Stack Element Limit Violation (sha256 with long preimage) ---"

# Step 1: Generate a long preimage (e.g., 300 bytes) inside the Docker container
CONTAINER_ID=$(docker ps -aqf "name=miniscript-test")
CONTAINER_PREIMAGE_PATH="/tmp/long_preimage_test.txt"

docker exec $CONTAINER_ID bash -c "head /dev/urandom | tr -dc A-Za-z0-9_ | head -c 300 > $CONTAINER_PREIMAGE_PATH"

# Retrieve the length and hash from inside the container
PREIMAGE_LENGTH=$(docker exec $CONTAINER_ID bash -c "wc -c < $CONTAINER_PREIMAGE_PATH" | awk '{print $1}')
SHA256_HASH=$(docker exec $CONTAINER_ID bash -c "sha256sum $CONTAINER_PREIMAGE_PATH" | awk '{print $1}')

echo "Generated a preimage of size: $PREIMAGE_LENGTH bytes (saved to $CONTAINER_PREIMAGE_PATH inside container)"
echo "SHA256 Hash of the preimage: $SHA256_HASH"

echo "Miniscript Policy: sha256($SHA256_HASH)"

echo "Explanation of Violation:"
echo "1. BIP110 Rule: OP_PUSHDATA* payloads and witness stack elements exceeding 256 bytes are invalid."
echo "2. sha256() Miniscript: This policy requires the original preimage to be pushed onto the witness stack for satisfaction."
echo "3. The Violation: The preimage generated for this test is $PREIMAGE_LENGTH bytes long. Since $PREIMAGE_LENGTH > 256, pushing this preimage onto the witness stack would violate the BIP110 limit."

# Clean up the temporary file inside the container
docker exec $CONTAINER_ID rm $CONTAINER_PREIMAGE_PATH

echo "This script demonstrates the policy. Satisfying this script with the generated preimage would lead to an invalid transaction under BIP110."
