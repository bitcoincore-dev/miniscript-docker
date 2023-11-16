# mint-001

## 3 Key Degrading Multisig

## Motivation

The 2-of-3 multisig serves as a standard in multisignature solutions,
offering a well-balanced combination of redundancy, security,
flexibility, and practicality for securing Bitcoin. Loss of a single key
does not spell disaster, and key distribution enhances security.
Miniscript\'s time feature enables further disaster recovery. If two
keys are lost, a timelock can convert the wallet to a 1-of-3 multisig.
The proposal outlines four conditions through Miniscript\'s
\`thresh()\`:

    1. Key 1
    2. Key 2
    3. Key 3
    4. Timelock (either relative or absolute)

Initially, the wallet requires 2-of-3 keys, functioning as a traditional
2-of-3 multisig. After the timelock expires, only one key is needed to
spend the funds.

# Timelock Values Note

- Descriptor template security is independent of relative or absolute timelock values; the impact is on timelock duration only. Reference transactions on testnet use short-duration timelocks; however, practical applications will vary.

- Relative timelock descriptors provide a persistent structure, requiring a self-send to extend timelock security, thus enabling standardized timelock durations.

- Absolute timelock descriptors need frequent updates; setting long-term timelock values becomes cumbersome. Updating these descriptors entails transferring coins to a new descriptor with revised absolute timelock values.

Suggested Relative Block Height Timelocks: older(32800)

- Mid-point block height relative timelock (\~278 days assuming constant hashrate)
older(65535

- Max duration block height relative timelock (~455 days assuming constant hashrate)

Suggested Relative Epoch Timelocks: older(4224679)

- Mid-point epoch time relative timelock (\~180 days, 6 months) older(4259839)

- Max duration epoch time relative timelock (\~388 days)

Below is a reference diagram on how the 3 Key Time Layered Multisig operates across time:

![](mint-001/diagram.jpg)

# Example Miniscript Output Descriptors

## 3 Key Time Lock Multisig

### Relative Blockheight Timelock

#### Policy:

<code>thresh(2,pk(XPUB1),pk(XPUB2),pk(XPUB3),older(100))</code>

#### Miniscript:

<code>thresh(2,pk(XPUB1),s:pk(XPUB2),s:pk(XPUB3),sln:older(100))</code>

#### Descriptor:

<code>wsh(thresh(2,pk(XPUB1),s:pk(XPUB2),s:pk(XPUB3),snl:older(100)))</code>

[Reference Testnet
Transaction](https://mempool.space/testnet/tx/13a204ec065f76878ee1f59f79b3eb2cea2b3fda4d8938e6cfa6a8394d090769)

### Absolute Blockheight Timelock

#### Policy:

<code>thresh(2,pk(XPUB1),pk(XPUB2),pk(XPUB3),older(2477600))</code>

#### Miniscript:

<code>thresh(2,pk(XPUB1),s:pk(XPUB2),s:pk(XPUB3),sln:older(2477600))</code>

#### Descriptor:

<code>wsh(thresh(2,pk(XPUB1),s:pk(XPUB2),s:pk(XPUB3),snl:after(2477600)))</code>

[Reference Testnet
Transaction](https://mempool.space/testnet/tx/df8a6946816a839f4de9d511ad902d740cc45ddddca3296de8fc11d1fd0c26f4)

### Absolute Epochtime Timelock

<code>wsh(thresh(2,pk(XPUB1),s:pk(XPUB2),s:pk(XPUB3),snl:after(1694563200)))</code>

[Reference Testnet
Transaction](https://mempool.space/testnet/tx/c0b80a8103e6af92a9bf8e7fb1faa8d073dae929138a2c6d747404cb46e6d690)

### Relative Epochtime Timelock

<code>wsh(thresh(2,pk(XPUB1),s:pk(XPUB2),s:pk(XPUB3),snl:older(4194400)))</code>

[Reference Testnet
Transaction](https://mempool.space/testnet/tx/1a9ba5a5a37a0df72dfbc28f57de89ce35bda1819afa73712bc29caa32164687)

(Future Addition: Taproot-based keyset for Minitapscript once integrated
into Core)
