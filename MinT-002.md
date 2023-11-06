      Miniscript Template: 2
      Title: 5 Key Time Layered Multisig
      Created: 2023-09-11

Name of Template {#name_of_template}
================

5 Key Degrading Multisig

Goal to be achieved by template {#goal_to_be_achieved_by_template}
===============================

Expanding upon the concept of a 3 key timed multisig, a 5 key timed
multisig allows for multiple timelocks to be introduced for additional
flexibility.

A timelock can be employed to allow a native 3 of 5 multisig to become 2
of 5, and eventually 1 of 5 for disaster recovery. This can be employed
by using a miniscript \`tresh()\` with seven conditions:

3 Conditions to be satisfied by:

    1. Key 1
    2. Key 2
    3. Key 3
    4. Key 4
    5. Key 5
    6. First timelock (either relative or absolute)
    7. Second timelock (either relative or absolute)

Timelock Values Note {#timelock_values_note}
====================

-   The security of the descriptor template is not dependent on the
    value of a relative or absolute timelock, as it only impacts the
    duration of the timelock. For reference transactions on testnet,
    short duration timelocks have been used, but in practice timelock
    values will differ.
-   Relative timelock descriptors offer a structure that can persist
    across time, requiring a self-send to extend the timelock security,
    and thus offering a better ability to have standard timelock
    durations within templates.
-   It is harder to set established timelock values with absolute
    timelock descriptors as they need to be regularly updated.

Suggested Relative Block Height Timelocks:

-   older(32800) - Halfway point of block height relative timelock
    (\~278 days assuming constant hashrate)

<!-- -->

-   older(65535) - maximum duration of a block height relative timelock
    (\~455 days assuming constant hashrate)

Suggested Relative Epoch Timmelocks:

-   older(4224680) - Approximate Halfway point of epoch time relative
    timelock (\~180 days, 6 months)

<!-- -->

-   older(4259839) - Maximum duration of an epoch time relative timelock
    (\~388 days)

Below is a reference diagram on how the 5 Key Time Layered Multisig
operates across time:

<img src=template-002/diagram.jpg></img>

Example Miniscript Output Descriptor {#example_miniscript_output_descriptor}
====================================

1\. 5 Key Time Lock Multisig - Relative Blockheight Timelock

`   wsh(thresh(3,pk(XPUB1),s:pk(XPUB2),s:pk(XPUB3),s:pk(XPUB4),s:pk(XPUB5),snu:older(100),snu:older(200)))`

[Reference Testnet
Transaction](https://mempool.space/testnet/tx/31e22b75d58323f7cfca225912a90d49ff959716babd9bad9fe6459a9f91b700)

2\. 5 Key Time Lock Multisig - Absolute Blockheight Timelock

`   wsh(thresh(3,pk(XPUB1),s:pk(XPUB2),s:pk(XPUB3),s:pk(XPUB4),s:pk(XPUB5),snu:after(1694563200),snu:after(1694563200)))`

[Reference Testnet
Transaction](https://mempool.space/testnet/tx/d6e1dd2e35ffcf111f3868ee38d22e70b2439d7b3bc1db064fef6d25eee3c506)

3\. 5 Key Time Lock Multisig - Absolute Epochtime Timelock

`   wsh(thresh(3,pk(XPUB1),s:pk(XPUB2),s:pk(XPUB3),s:pk(XPUB4),s:pk(XPUB5),snu:after(1694563200),snu:after(1694476800)))`

[Reference Testnet
Transaction](https://mempool.space/testnet/tx/caba0f5b81beac934aeed0b93a1a683bc86cf85b3bc935284404bfddb9ab0156)

4\. 5 Key Time Lock Multisig - Relative Epochtime Timelock

`   wsh(thresh(3,pk(XPUB1),s:pk(XPUB2),s:pk(XPUB3),s:pk(XPUB4),s:pk(XPUB5),snu:older(4194400),snu:older(4194500)))`

[Reference Testnet
Transaction](https://mempool.space/testnet/tx/747087e37aadf7965568d5efa0a02ccc328908539c99e30fcb1bb9631554e317)

(To Add Taproot descriptors once Minitapscript is merged into Core)

\_\_NOTOC\_\_