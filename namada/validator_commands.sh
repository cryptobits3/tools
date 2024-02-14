# create wallet
namadaw gen --alias $WALLET

# restore existing wallet
namadaw derive --alias $WALLET

# find your wallet address
namadaw find --alias $WALLET

# Fund your wallet from faucet - https://faucet.heliax.click/
# check balance
namadac balance --owner $WALLET

# list known keys and addresses in the wallet
namadaw list

# delete wallet
namadaw remove --alias $WALLET --do-it

# Check Sync status, once your node is fully synced, the output from above will say false
curl http://127.0.0.1:26657/status | jq 

# initiate a validator
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
