# Wallet Commands

## Create wallet
~~~
namadaw gen --alias $WALLET
~~~

## Restore existing wallet
~~~
namadaw derive --alias $WALLET
~~~

## Find your wallet address
~~~
namadaw find --alias $WALLET
~~~

## Fund your wallet from faucet - https://faucet.heliax.click/
## Check balance
~~~
namadac balance --owner $WALLET
~~~

## List known keys and addresses in the wallet
~~~
namadaw list
~~~

## Send payment from one address to another:
~~~
namada client transfer --source $WALLET --target ${WALLET}1 --token NAAN --amount 1 --signing-keys $WALLET --memo $MEMO
~~~

## Delete wallet
~~~
namadaw remove --alias $WALLET --do-it
~~~

## Check Sync status, once your node is fully synced, the output from above will say false
~~~
curl http://127.0.0.1:26657/status | jq 
~~~

# Init Validator

## Initiate a validator
~~~
namadac init-validator \
		--commission-rate 0.07 \
		--max-commission-rate-change 1 \
		--signing-keys $WALLET \
		--alias $ALIAS \
		--email <EMAIL_ADDRESS> \
		--website <WEBSITE> \ 
		--discord-handle <DISCORD> \
		--account-keys $WALLET \
		--memo $MEMO
~~~

## Find your established validator address
~~~
namadaw list | grep -A 1 ""$ALIAS"" | grep "Established"
~~~

## Replace your Validator address, save and import variables into system
~~~
VALIDATOR_ADDRESS=$(namadaw list | grep -A 1 "\"$ALIAS\"" | grep "Established" | awk '{print $3}') 
echo "export VALIDATOR_ADDRESS="$VALIDATOR_ADDRESS"" >> $HOME/.bash_profile 
source $HOME/.bash_profile
~~~

## Restart the node and wait for 2 epochs
~~~
sudo systemctl restart namadad && sudo journalctl -u namadad -f
~~~

## Check epoch
~~~
namada client epoch
~~~


# Delegate stake

## Delegate tokens
~~~
namadac bond --source $WALLET --validator $VALIDATOR_ADDRESS --amount 10 --node tcp://namada-testnet-tcprpc.itrocket.net:33657 --memo $MEMO
~~~

## Wait for 3 epochs and check validator is in the consensus set
~~~
namadac validator-state --validator $ALIAS
~~~

## Check your validator bond status
~~~
namada client bonds --owner $WALLET
~~~

## Find your validator status
~~~
namada client validator-state --validator $VALIDATOR_ADDRESS
~~~

## Add stake
~~~
namadac bond --source $WALLET --validator $VALIDATOR_ADDRESS --amount 10 --node tcp://namada-testnet-tcprpc.itrocket.net:33657 --memo $MEMO
~~~

## Query the set of validators
~~~
namadac bonded-stake
~~~

## Unbond the tokens
~~~
namada client unbond --source $WALLET --validator $VALIDATOR_ADDRESS --amount 1.5 --node tcp://namada-testnet-tcprpc.itrocket.net:33657 --memo $MEMO
~~~

## Wait for 6 epochs, then check when the unbonded tokens can be withdrawed
~~~
namadac bonds --owner $WALLET
~~~

## Withdraw the unbonded tokens
~~~
namada client withdraw --source $WALLET --validator $VALIDATOR_ADDRESS --node tcp://namada-testnet-tcprpc.itrocket.net:33657 --memo $MEMO
~~~

## Redelegate
~~~
namadac redelegate --owner $WALLET --source-validator <source-validator> --destination-validator <destination-validator> --amount 10 --memo $MEMO
~~~

## Claim rewards
~~~
namadac claim-rewards --source $WALLET --validator $VALIDATOR_ADDRESS --memo $MEMO
~~~

## Query the pending reward tokens without claiming
~~~
namadac rewards --source $WALLET --validator $VALIDATOR_ADDRESS --memo $MEMO
~~~


# Multisign

## Generate key_1:
~~~
namada wallet gen --alias $WALLET
~~~

## Generate key_2 and etc:
~~~
namada wallet gen --alias ${WALLET}1
~~~

## Chech your public key:
~~~
namada wallet find --alias $WALLET | awk '/Public key:/ {print $3}'
~~~

## Init non-multisig account (single signer):
~~~
namada client init-account --alias ${WALLET}-multisig --public-keys <WALLET-public-key> --signing-keys $WALLET --memo $MEMO
~~~

## Init multisig account (at least 2 signers):
~~~
namada client init-account --alias ${WALLET}1-multisig --public-keys <WALLET-public-key>,<WALLET1-public-key> --signing-keys $WALLET,${WALLET}1 --threshold 2 --memo $MEMO
~~~

## Create a folder for a transaction:
~~~
mkdir tx_dumps
~~~

## Create transaction:
~~~
namada client transfer --source ${WALLET}1-multisig --target ${WALLET}1 --token NAAN --amount 10 --signing-keys $WALLET,${WALLET}1 --dump-tx --output-folder-path tx_dumps --memo $MEMO
~~~

## Sign the transaction:
~~~
namada client sign-tx --tx-path "<path-to-.tx-file>" --signing-keys $WALLET,${WALLET}1 --owner ${WALLET}1-multisig --memo $MEMO
~~~

## Save as a variable offline_signature 1:
~~~
export SIGNATURE_ONE="<signature-file-name>"
~~~

## Save as a variable offline_signature 2:
~~~
export SIGNATURE_TWO="<signature-2-file-name>"
~~~

## Submit transaction:
~~~
namada client tx --tx-path "<path-to-.tx-file>" --signatures $SIGNATURE_ONE,$SIGNATURE_TWO --owner ${WALLET}1-multisig --gas-payer $WALLET --memo $MEMO
~~~

## Changing the multisig threshold:
~~~
namada client update-account --address ${WALLET}1-multisig --threshold 1 --signing-keys $WALLET,${WALLET}1 --memo $MEMO
~~~

## Check that the threshold has been updated correctly by running:
~~~
namada client query-account --owner ${WALLET}1-multisig
~~~

## Changing the public keys of a multisig account:
~~~
namada client update-account --address ${WALLET}1-multisig --public-keys ${WALLET}2,${WALLET}3,${WALLET}4 --signing-keys $WALLET,${WALLET}1 --memo $MEMO
~~~

## Initialize an established account:
~~~
namada client init-account --alias ${WALLET}1-multisig --public-keys ${WALLET}2,${WALLET}3,${WALLET}4  --signing-keys $WALLET,${WALLET}1  --threshold 1 --memo $MEMO
~~~


# MASP

## Randomly generate a new spending key:
~~~
namada wallet gen --shielded --alias ${WALLET}-shielded --memo $MEMO
~~~

## Create a new payment address:
~~~
namada wallet gen-payment-addr --key ${WALLET}-shielded --alias ${WALLET}-shielded-addr --memo $MEMO
~~~

## Send a shielding transfer:
~~~
namada client transfer --source $WALLET --target ${WALLET}-shielded-addr --token NAAN --amount 5 --memo $MEMO
~~~

## View balance:
~~~
namada client balance --owner ${WALLET}-shielded
~~~

## Generate another spending key:
~~~
namada wallet gen --shielded --alias ${WALLET}1-shielded --memo $MEMO
~~~

## Create a payment address:
~~~
namada wallet gen-payment-addr --key ${WALLET}1-shielded --alias ${WALLET}1-shielded-addr --memo $MEMO
~~~

## Shielded transfers (once the user has a shielded balance, it can be transferred to another shielded address):
~~~
namada client transfer  --source ${WALLET}-shielded --target ${WALLET}1-shielded-addr --token NAAN --amount 5 --signing-keys <your-implicit-account-alias> --memo $MEMO
~~~

## Unshielding transfers (from a shielded to a transparent account):
~~~
namada client transfer --source ${WALLET}-shielded --target $WALLET --token NAAN --amount 5 --signing-keys <your-implicit-account-alias> --memo $MEMO
~~~


# Validator Operatiions

## Check sync status and node info:
~~~
curl http://127.0.0.1:26657/status | jq
~~~

## Check balance:
~~~
namada client balance --owner $ALIAS
~~~

## Check keys:
~~~
namada wallet list
~~~

## Find your validator address:
~~~
namada client find-validator --tm-address=$(curl -s localhost:26657/status | jq -r .result.validator_info.address) --node localhost:26657
~~~

## Stake funds:
~~~
namadac bond --source $WALLET --validator $VALIDATOR_ADDRESS --amount 10 --memo $MEMO
~~~

## Self-bonding:
~~~
namadac bond --validator $VALIDATOR_ADDRESS --amount 10 --memo $MEMO
~~~

## Check your validator bond status:
~~~
namada client bonds --owner $ALIAS
~~~

## Check your user bonds:
~~~
namada client bonds --owner $WALLET
~~~

## Check all bonded nodes:
~~~
namada client bonded-stake
~~~

## Find all the slashes:
~~~
namada client slashes
~~~

## Non-self unbonding (validator alias can be used instead of address):
~~~
namada client unbond --source $WALLET --validator $VALIDATOR_ADDRESS --amount 1.5 --memo $MEMO
~~~

## Self-unbonding:
~~~
namada client unbond --validator $VALIDATOR_ADDRESS --amount 1.5 --memo $MEMO
~~~

## Withdrawing unbonded tokens (available 6 epochs after unbonding):
~~~
namada client withdraw --source $WALLET --validator $VALIDATOR_ADDRESS --memo $MEMO
~~~

## Find your validator status:
~~~
namada client validator-state --validator $VALIDATOR_ADDRESS
~~~

## Check epoch:
~~~
namada client epoch
~~~

## Unjail, you need to wait 2 epochs:
~~~
namada client unjail-validator --validator $VALIDATOR_ADDRESS --node tcp://127.0.0.1:26657 --memo $MEMO
~~~

## Change validator commission rate:
~~~
namadac change-commission-rate --validator $VALIDATOR_ADDRESS --commission-rate <commission-rate> --memo $MEMO
~~~

## Change consensus key:
~~~
namadac change-consensus-key --validator $VALIDATOR_ADDRESS --memo $MEMO
~~~

## Change validator metadata:
~~~
namadac change-metadata --validator $VALIDATOR_ADDRESS --memo $MEMO
~~~

## Deactivate validator:
~~~
namadac deactivate-validator --validator $VALIDATOR_ADDRESS --memo $MEMO
~~~

## Reactivate validator:
~~~
namadac reactivate-validator --validator $VALIDATOR_ADDRESS --memo $MEMO
~~~


# Governance

## All proposals list:
~~~
namadac query-proposal
~~~

## Vote:
~~~
namadac vote-proposal --proposal-id <PROPOSAL_ID> --vote yay --address $ADDRESS --memo $MEMO
~~~

## Voting for PGF proposals:
~~~
namada client vote-proposal \
    --proposal-id <proposal-id-of-steward-proposal> \
    --vote yay \
    --signing-keys $WALLET \
    --memo $MEMO
~~~


# Sync and Consensus
## Check logs:
~~~
sudo journalctl -u namadad -f
~~~

## Check sync status and node info:
~~~
curl http://127.0.0.1:26657/status | jq
~~~

## Check consensus state:
~~~
curl -s localhost:26657/consensus_state | jq .result.round_state.height_vote_set[0].prevotes_bit_array
~~~

## Full consensus state:
~~~
curl -s localhost:12657/dump_consensus_state
~~~

## Your validator votes (prevote):
~~~
curl -s http://localhost:26657/dump_consensus_state | jq '.result.round_state.votes[0].prevotes' | grep $(curl -s http://localhost:26657/status | jq -r '.result.validator_info.address[:12]')
~~~
