
## Miniscript Templates (MinT)

## About

[Miniscript](https://bitcoin.sipa.be/miniscript/) is a language for
composing Bitcoin [Script](https://en.bitcoin.it/wiki/Script) in a
structured way, facilitating analysis, composition, and generic signing.
It's a simplified, composable subset of the Bitcoin
[Script](https://en.bitcoin.it/wiki/Script) language. Developed to
overcome limitations in writing complex spending conditions directly in
Bitcoin [Script](https://en.bitcoin.it/wiki/Script), it enables formal
verification and offers a more human-friendly interface.

## Objective

1.  Each MinT provides an example of a common miniscript implementation.
2. Each MinT is provided as is. While care is taken to ensure a high degree of quality. Developers and enthusiasts assume full responsibility for their usage[^use-at-your-own-risk]. 
1.  Have reviewed templates that leverage Miniscript to assure there are
    not unintended ways of executing a valid spend beyond the intended
    [Miniscript](https://raw.githubusercontent.com/bitcoin/bitcoin/master/src/script/miniscript.h)
    policy.

1.  Have standardized usages of Miniscript to streamline software and
    hardware wallet integrations.

1.  Have uniform on-chain usage of Miniscript templates for better
    privacy.

<HR>

<H2>
Submission Format

</H2>

### Name of Template

#### MinT-###-\<description\>

### Policy Description

A 3-of-3 multisig quorum that **transitions** to a 2-of-3 after 90 days[^three-of-three]

### Policy Implementation

Input[^2]:
> thresh(3, pk(key_1), pk(key_2), pk(key_3), older(12960))

Output[^3]:
> thresh(3, pk(key_1), s:pk(key_2), s:pk(key_3), sln:older(12960))

A fragment note[^4].

> s:X	SWAP [X]	
> n:X	[X] 0NOTEQUAL	
> l:X = or_i(0,X)	IF 0 ELSE [X] ENDIF

A footnote[^6].

Resulting Bitcoin Script structure[^7].

    <key_1> OP_CHECKSIG OP_SWAP <key_2> OP_CHECKSIG OP_ADD OP_SWAP <key_3>
    OP_CHECKSIG OP_ADD OP_SWAP OP_IF
      0
    OP_ELSE
      <a032> OP_CHECKSEQUENCEVERIFY OP_0NOTEQUAL
    OP_ENDIF
    OP_ADD 3 OP_EQUAL

Spending cost analysis[^5]:

> Script: 122 WU	
> Input: 166.250000 WU	
> Total: 288.250000 WU	

### Reference Tx

###### Provide a reference transaction so behavior and outcomes can be verified.

TxID:

[testnet](https://mempool.space/testnet/tx/13a204ec065f76878ee1f59f79b3eb2cea2b3fda4d8938e6cfa6a8394d090769):[13a204ec065f76878ee1f59f79b3eb2cea2b3fda4d8938e6cfa6a8394d090769](https://mempool.space/testnet/tx/13a204ec065f76878ee1f59f79b3eb2cea2b3fda4d8938e6cfa6a8394d090769)

### Additional Links

[usage
example](https://github.com/sipa/miniscript/blob/master/bitcoin/script/miniscript.h)

### Additional Resources

[
github.com/sipa/miniscript/tree/master](https://github.com/sipa/miniscript/tree/master "wikilink")

[
bitcoin.sipa.be/miniscript](https://bitcoin.sipa.be/miniscript "wikilink")

===

[^three-of-three]: `144 blocks per day x 90 days = 12960 blocks`	additonal info here: [miniscript.h](https://github.com/bitcoin/bitcoin/blob/d9007f51a7480246abe4c16f2e3d190988470bec/src/script/miniscript.h#L199)
  
[^2]: `nSequence ≥ n > 0` (add link)
  `older(NUM) ~> <NUM> CHECKSEQUENCEVERIFY`
  	additonal info here: [miniscript.h](https://github.com/bitcoin/bitcoin/blob/d9007f51a7480246abe4c16f2e3d190988470bec/src/script/miniscript.h#L172)

[^3]: `nLockTime ≥ n > 0` (add link)
  `after(NUM) ~> <NUM> CHECKLOCKTIMEVERIFY`
   additonal info here: [miniscript.h](https://github.com/bitcoin/bitcoin/blob/d9007f51a7480246abe4c16f2e3d190988470bec/src/script/miniscript.h#L172)

[^4]: Given a script, be able to predict the cost of spending an output.
  
  
[^5]: "s" Signed: satisfying this expression always requires a signature (predicting whether all satisfactions will be HASSIG).
[^6]: "f" Forced: dissatisfying this expression always requires a signature (predicting whether all dissatisfactions will be HASSIG).
[^7]: "e" Expressive: this requires a unique unconditional dissatisfaction to exist, and forces all conditional dissatisfactions (if any) to require a signature.

[^use-at-your-own-risk]: Use at your own risk.


<!--
\_\_NOTOC\_\_
-->
