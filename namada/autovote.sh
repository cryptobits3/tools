#!/bin/bash

# Saving wallet address
WALLET_ADDRESS=$(namadaw find --alias $WALLET | grep "Implicit" | awk '{print $3}') 
echo "export WALLET_ADDRESS="$WALLET_ADDRESS"" >> $HOME/.bash_profile 
source $HOME/.bash_profile

# Writing the output
prop_list=$(namadac query-proposal)

# Extract last committed epoch
last_epoch=$(echo "$prop_list" | grep -oP 'Last committed epoch: \K\d+')

# Extract ID
id=$(echo "$prop_list" | grep -oP 'id: \K\d+')

# Extract proposals and process each one
while read -r line; do
    if [[ $line =~ "Proposal Id: " ]]; then
        # Extract proposal ID
        prop_id=$(echo "$line" | grep -oP 'Proposal Id: \K\d+')
        
        # Extract Start Epoch
        start_epoch=$(echo "$line" | grep -oP 'Start Epoch: \K\d+')

        # Check if Start Epoch is equal to Last Committed Epoch + 1
        if [[ $start_epoch -eq $((last_committed_epoch + 1)) ]]; then
            # Vote using the sample command
            namadac vote-proposal --proposal-id $prop_id --vote yay --address $WALLET_ADDRESS --memo $MEMO
            echo "voted $prop_id"
        fi

        # Check if Prop ID equals ID, if so, end the script
        if [[ $prop_id -eq $id ]]; then
            echo "Reached last committed proposal. Exiting..."
            exit 0
        fi
    fi
done <<< "$output"
