Miniscript Templates {#miniscript_templates}
--------------------

  --------------------------------- --------------------------------- --------------------------------- --------------------------------- ---------------------------------
  [MinT-000](MinT-000 "wikilink")   [MinT-001](MinT-001 "wikilink")   [MinT-002](MinT-002 "wikilink")   [MinT-003](MinT-003 "wikilink")   [MinT-004](MinT-004 "wikilink")
  --------------------------------- --------------------------------- --------------------------------- --------------------------------- ---------------------------------

About
-----

[Miniscript](https://bitcoin.sipa.be/miniscript/) is a language for
composing Bitcoin [Script](https://en.bitcoin.it/wiki/Script) in a
structured way, facilitating analysis, composition, and generic signing.
It\'s a simplified, composable subset of the Bitcoin
[Script](https://en.bitcoin.it/wiki/Script) language. Developed to
overcome limitations in writing complex spending conditions directly in
Bitcoin [Script](https://en.bitcoin.it/wiki/Script), it enables formal
verification and offers a more human-friendly interface.

Goals
-----

1.  Have reviewed templates that leverage Miniscript to assure there are
    not unintended ways of executing a valid spend beyond the intended
    [Miniscript](https://raw.githubusercontent.com/bitcoin/bitcoin/master/src/script/miniscript.h)
    policy.

<!-- -->

1.  Have standardized usages of Miniscript to streamline software and
    hardware wallet integrations.

<!-- -->

1.  Have uniform on-chain usage of Miniscript templates for better
    privacy.

<H2>

Submission Format

</H2>

### Name of Template {#name_of_template}

Proposed Timelock Usage

### Goal to be achieved by template {#goal_to_be_achieved_by_template}

A 3-of-3 that turns into a 2-of-3 after 90 days

`   NOTE: 144 blocks per day x 90 days = 12960 blocks`

### Miniscript Policy {#miniscript_policy}

Input:

    thresh(3, pk(key_1), pk(key_2), pk(key_3), older(12960))

Output:

    thresh(3, pk(key_1), s:pk(key_2), s:pk(key_3), sln:older(12960))

    Spending cost analysis

    Script: 122 WU
    Input: 166.250000 WU
    Total: 288.250000 WU

<h4>

Resulting Bitcoin Script structure

</h4>


    <key_1> OP_CHECKSIG OP_SWAP <key_2> OP_CHECKSIG OP_ADD OP_SWAP <key_3>
    OP_CHECKSIG OP_ADD OP_SWAP OP_IF
      0
    OP_ELSE
      <a032> OP_CHECKSEQUENCEVERIFY OP_0NOTEQUAL
    OP_ENDIF
    OP_ADD 3 OP_EQUAL

[testnet
tx](https://mempool.space/testnet/tx/13a204ec065f76878ee1f59f79b3eb2cea2b3fda4d8938e6cfa6a8394d090769)

`   `[`https://mempool.space/testnet/tx/13a204ec065f76878ee1f59f79b3eb2cea2b3fda4d8938e6cfa6a8394d090769`](https://mempool.space/testnet/tx/13a204ec065f76878ee1f59f79b3eb2cea2b3fda4d8938e6cfa6a8394d090769)

### Additional Links {#additional_links}

[usage
example](https://github.com/sipa/miniscript/blob/master/bitcoin/script/miniscript.h)

### Additional Resources {#additional_resources}

[
github.com/sipa/miniscript/tree/master](https://github.com/sipa/miniscript/tree/master "wikilink")

[
bitcoin.sipa.be/miniscript](https://bitcoin.sipa.be/miniscript "wikilink")

\_\_NOTOC\_\_
