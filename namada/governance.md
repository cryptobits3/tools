## Governance

All proposals list:
~~~
namadac query-proposal
~~~

Edit proposal
~~~
namadac query-proposal --proposal-id <PROPOSAL_ID>
~~~

Vote:
~~~
namadac vote-proposal --proposal-id <PROPOSAL_ID> --vote yay --address $ADDRESS --memo $MEMO
~~~

Voting for PGF proposals:
~~~
namada client vote-proposal \
    --proposal-id <proposal-id-of-steward-proposal> \
    --vote yay \
    --signing-keys $WALLET \
    --memo $MEMO
~~~
