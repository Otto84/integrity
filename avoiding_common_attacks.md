it is a simple contract.
I'm reading a lot of articles and example on this really important argument..
expecially for the part of the aution in the nft dapp that I'm planning.

for example:
- Re-entracy Attacks, easy to avoid if you setting the userBalances[msg.sender] = 0; before the external call.

- Denial of Service with Failed Call (SWC-113),another potential danger of passing execution to another contract. like in the example in the section 9 lesson 3
