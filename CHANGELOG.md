# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- New Miniscript function `do_nothing()` which compiles to `OP_1`.
- Test script `test_bip110_output_limit_pkA.sh` to demonstrate BIP110 34-byte transaction output limit violation.
- Test script `test_bip110_witness_stack_limit_sha256.sh` to demonstrate BIP110 256-byte witness stack element limit violation.
- Test script `test_bip110_complex_scriptpubkey_limit.sh` to demonstrate BIP110 34-byte `scriptPubKey` limit violation with complex Miniscript.
- Test script `test_bip110_op_return_data_limit.sh` to demonstrate BIP110 83-byte `OP_RETURN` data limit violation.
- `test_harness.sh` script to run all BIP110 test scripts.
- GitHub Actions workflow `.github/workflows/test_harness_workflow.yml` to automate running the test harness.

### Changed
- Added verbose logging (`set -x` and descriptive `echo`s) to all BIP110 test scripts for improved clarity and debuggability.
- Modified `test_bip110_witness_stack_limit_sha256.sh` and `test_bip110_op_return_data_limit.sh` to dynamically detect Docker container ID and execute internal commands within the container for robustness.
- Updated `test_bip110_complex_scriptpubkey_limit.sh` to use a here-document for robust multi-line output.

### Fixed
- Corrected shell syntax errors in `test_bip110_complex_scriptpubkey_limit.sh` and `test_bip110_op_return_data_limit.sh` related to unescaped characters and command execution.
- Installed `xxd` in the Docker container to support hex encoding in `test_bip110_op_return_data_limit.sh`.

### Chore
- Added `.genkit/` to `.gitignore` to prevent tracking local Genkit-related files.
