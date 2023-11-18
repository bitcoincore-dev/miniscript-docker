# mint-002

## 5 Key Degrading Multisig

## Motivation

Expanding upon the concept of a [2-of-3 key timed multisig](mint-001.md) [(mint-001)](mint-001.md), a 5 key timed multisig allows for multiple timelocks to be introduced for additional flexibility.

A timelock can be employed to allow a native 3-of-5 multisig to become 2-of-5, and eventually 1-of-5 for disaster recovery. 

This can be employed by using a miniscript `tresh()` with seven conditions:

### 3 Layer Conditions to be satisfied using:

#### Base expressions (type B). 

1. **timelock**: **after(**int**)**[^after] or **older(**int**)** - either **relative** or **absolute** [^timelock].

2. **timelock**: **after(**int**)** or **older(**int**)**[^older]  - either **relative** or **absolute** [^either].

#### Key expressions[^k_type] (type K).

1. **pk(**key1**)** [^pk_key1]

2. **pk(**key2**)** [^pk_key2]

3. **pk(**key3**)** [^pk_key3]

4. **pk(**key4**)** [^pk_key4]

5. **pk(**key5**)** [^pk_key5]


### More on Timelock Values

- The security of the descriptor template is not dependent on the value of a relative or absolute timelock, as it only impacts the duration of the timelock.
    
- For reference transactions on testnet, short duration timelocks have been used. In practice timelock values will differ.
    
- Relative timelock descriptors offer a structure that can persist across time, requiring a self-send to extend the timelock security, and thus offering a better ability to have standard timelock durations within templates.
    
- It is harder to set established timelock values with absolute timelock descriptors as they need to be regularly updated.

##### Suggested Relative Block Height Timelocks:

- **older(**32800**)** - Halfway point of block height relative timelock [^278days]

- **older(**65535**)** - Maximum duration of a block height relative timelock [^455days]

##### Suggested Relative Epoch Timmelocks:

- **older(**4224680**)** - Approximate Halfway point of epoch time relative timelock [^180days]

- **older(**4259839**)** - Maximum duration of an epoch time relative timelock [^388days]


Below is a reference diagram on how the 5 Key Time Layered Multisig
operates across time:

![](mint-002/diagram.jpg)

# Example Miniscript Output Descriptor

## 5 Key Time Lock Multisig

### Relative Blockheight Timelock

<code>wsh(thresh(3,pk(XPUB1),s:pk(XPUB2),s:pk(XPUB3),s:pk(XPUB4),s:pk(XPUB5),snu:older(100),snu:older(200)))</code>

[Reference Testnet
Transaction](https://mempool.space/testnet/tx/31e22b75d58323f7cfca225912a90d49ff959716babd9bad9fe6459a9f91b700)

### Absolute Blockheight Timelock

<code>wsh(thresh(3,pk(XPUB1),s:pk(XPUB2),s:pk(XPUB3),s:pk(XPUB4),s:pk(XPUB5),snu:after(1694563200),snu:after(1694563200)))</code>

[Reference Testnet
Transaction](https://mempool.space/testnet/tx/d6e1dd2e35ffcf111f3868ee38d22e70b2439d7b3bc1db064fef6d25eee3c506)

### Absolute Epochtime Timelock

<code>wsh(thresh(3,pk(XPUB1),s:pk(XPUB2),s:pk(XPUB3),s:pk(XPUB4),s:pk(XPUB5),snu:after(1694563200),snu:after(1694476800)))</code>

[Reference Testnet
Transaction](https://mempool.space/testnet/tx/caba0f5b81beac934aeed0b93a1a683bc86cf85b3bc935284404bfddb9ab0156)

### Relative Epochtime Timelock

<code>wsh(thresh(3,pk(XPUB1),s:pk(XPUB2),s:pk(XPUB3),s:pk(XPUB4),s:pk(XPUB5),snu:older(4194400),snu:older(4194500)))</code>

[Reference Testnet
Transaction](https://mempool.space/testnet/tx/747087e37aadf7965568d5efa0a02ccc328908539c99e30fcb1bb9631554e317)

(To Add Taproot descriptors once Minitapscript is merged into Core)

[^278days]: **~278 days** ***assuming constant hashrate***

[^455days]: **~455 days** ***assuming constant hashrate***

[^180days]: **~180 days** ***6 months***

[^388days]: **~388 days**

<!--
               fragment     fragment      ->     Bitcoin Script
-->

[^pk_key1]: **`pk(key1) = c:pk_k(key1)`** --> **`<key1> CHECKSIG`**
[^pk_key2]: **`pk(key2) = c:pk_k(key2)`** --> **`<key2> CHECKSIG`**
[^pk_key3]: **`pk(key3) = c:pk_k(key3)`** --> **`<key3> CHECKSIG`**
[^pk_key4]: **`pk(key4) = c:pk_k(key4)`** --> **`<key4> CHECKSIG`**
[^pk_key5]: **`pk(key5) = c:pk_k(key5)`** --> **`<key5> CHECKSIG`**

[^abs_timelock]: **after(**int**)**, **older(**int**)**: Require that the **nLockTime** or **nSequence** value is at least (**int**).


[^rel_timelock]: **after(**int**)**, **older(**int**)**: Require that the **nLockTime** or **nSequence** value is at least (**int**).


[^timelock]: **NUM** cannot be **0**.

[^older]: **older(**n**)** = **<n>** **CHECKSEQUENCEVERIFY**

[^after]: **after(**n**)** = **<n>** **CHECKLOCKTIMEVERIFY**

[^either]: either **relative**[^rel_timelock] or **absolute**[^abs_timelock]


[^k_type]: **Key** expressions (**K Type**) take their inputs from the top of the stack, but instead of verifying a condition directly they always push a public key onto the stack, for which a signature is still required to satisfy the expression. **A "K" can be converted into a "B" using the c: wrapper (CHECKSIG)**. <!-- P. Wuille -->