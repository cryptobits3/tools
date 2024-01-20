#!/bin/bash

read -p "Enter config directory absolute path: " CONFIG_PATH

sed -i -e "s/^pruning *=.*/pruning = \"nothing\"/" \
       -e "/^\[api\]$/,/^\[/ s/^enable *=.*/enable = \"true\"/" \
       -e "/^\[api\]$/,/^\[/ s/^swagger *=.*/swagger = \"true\"/" \
       -e "/^\[api\]$/,/^\[/ s/^enabled-unsafe-cors *=.*/enabled-unsafe-cors = \"true\"/" \
       -e "/^\[rosetta\]$/,/^\[/ s/^enable *=.*/enable = \"false\"/" \
       -e "/^\[grpc\]$/,/^\[/ s/^enable *=.*/enable = \"true\"/" \
       -e "/^\[grpc-web\]$/,/^\[/ s/^enable *=.*/enable = \"true\"/" \
       -e "/^\[grpc-web\]$/,/^\[/ s/^enable-unsafe-cors *=.*/enable-unsafe-cors = \"true\"/" \
       -e "/^\[grpc-web\]$/,/^\[/ s/^enable-unsafe-cors *=.*/enable-unsafe-cors = \"true\"/" \
       -e "/^\[state-sync\]$/,/^\[/ s/^snapshot-interval *=.*/snapshot-interval = \"1000\"/" \
       -e "/^\[state-sync\]$/,/^\[/ s/^snapshot-keep-recent *=.*/snapshot-keep-recent = \"2\"/" \
       "${CONFIG_PATH}app.toml"

sed -i -e "s/^cors_allowed_origins *=.*/cors_allowed_origins = \"\["*"\]\"/" \
       -e "s/^indexer *=.*/indexer = \"kv\"/" \
       -e "s/^prometheus *=.*/prometheus = \"false\"/" \
       -e "s/^filter_peers *=.*/filter_peers = \"true\"/" \
       "${CONFIG_PATH}config.toml"
