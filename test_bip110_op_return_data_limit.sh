#!/bin/bash
set -x

echo "--- Testing BIP110 83-byte OP_RETURN Data Limit Violation ---"

# Define the desired data length (greater than 83 bytes)
DESIRED_DATA_LENGTH=100

# Dynamically detect the Docker container ID
echo "Detecting Docker container ID for 'miniscript-test'..."
CONTAINER_ID=$(docker ps -aqf "name=miniscript-test")
CONTAINER_DATA_PATH="/tmp/op_return_data.bin"

if [ -z "$CONTAINER_ID" ]; then
    echo "Error: Miniscript Docker container 'miniscript-test' not found or not running."
    echo "Please ensure the container is running with 'docker run -p 8080:8080 -d --name miniscript-test miniscript-web serve' before running this script."
    exit 1
else
    echo "Detected container ID: $CONTAINER_ID"
fi

echo "Generating a random payload of $DESIRED_DATA_LENGTH bytes inside the Docker container at $CONTAINER_DATA_PATH..."
docker exec "$CONTAINER_ID" bash -c "head /dev/urandom | head -c $DESIRED_DATA_LENGTH > $CONTAINER_DATA_PATH"
echo "Payload generated."

# Retrieve the hex-encoded data and actual length from inside the container
echo "Retrieving hex-encoded data and its length from inside the container..."
HEX_DATA=$(docker exec "$CONTAINER_ID" bash -c "xxd -p $CONTAINER_DATA_PATH | tr -d \n")
DATA_LENGTH=$(echo -n "$HEX_DATA" | wc -c)
DATA_LENGTH=$((DATA_LENGTH / 2)) # Hex chars are 2 per byte
echo "Data retrieval complete. Actual data length: $DATA_LENGTH bytes."

echo "Generated a data payload of size: $DATA_LENGTH bytes (desired: $DESIRED_DATA_LENGTH bytes)"
echo "Conceptual OP_RETURN Script: OP_RETURN <$DATA_LENGTH-byte-hex-data> (e.g., OP_RETURN $HEX_DATA)"

echo "Explanation of Violation (Technical 'Confiscation'):"
echo "1. BIP110 Rule: If the first opcode is OP_RETURN, the scriptPubKey (including OP_RETURN and data) must not exceed 83 bytes."
echo "2. Conceptual Script: We've created an OP_RETURN script attempting to embed a $DATA_LENGTH-byte payload."
echo "3. Violation: $DATA_LENGTH bytes > 83 bytes. This conceptual script, if included in a transaction output, would be invalid under BIP110."
echo "4. Implication ('Confiscation'): The ability to embed data larger than 83 bytes using OP_RETURN would be blocked on a BIP110-enforcing chain. This restricts certain use cases that rely on larger arbitrary data storage in transactions, effectively 'confiscating' that functionality."

# Clean up the temporary file inside the container
echo "Cleaning up temporary file $CONTAINER_DATA_PATH inside the container..."
docker exec "$CONTAINER_ID" rm "$CONTAINER_DATA_PATH"
echo "Cleanup complete."

echo "This script demonstrates a conceptual violation of the OP_RETURN data limit under BIP110."
