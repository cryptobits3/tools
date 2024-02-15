#!/bin/bash

# Writing the output
prop_list=$(namadac query-proposal)

# Extract last committed epoch
last_epoch=$(echo "$prop_list" | grep -oP 'Last committed epoch: \K\d+')

# Extract ID
id=$(echo "$prop_list" | grep -oP 'id: \K\d+')

# Extract proposals and process each one
while read -r line; do
    echo $line
    if [[ $line =~ "Proposal Id: " ]]; then
        # Extract proposal ID
        prop_id=$(echo "$line" | grep -oP 'Proposal Id: \K\d+')
        echo $prop_id
        # Extract Start Epoch
        start_epoch=$(echo "$line" | grep -oP 'Start Epoch: \K\d+')

        # Extract Author
        author_addr=$(echo "$line" | grep -oP 'Author: \K\S+')

        # Check if Start Epoch is equal to Last Committed Epoch + 1
        if [[ $start_epoch -eq $((last_committed_epoch + 1)) ]]; then
            # Vote using the sample command
            namadac vote-proposal --proposal-id $prop_id --vote yay --address $author_addr --memo $MEMO
            echo "voted $prop_id"
        fi

        # Check if Prop ID equals ID, if so, end the script
        if [[ $prop_id -eq $id ]]; then
            echo "Reached last committed proposal. Exiting..."
            exit 0
        fi
    fi
done <<< "$output"
