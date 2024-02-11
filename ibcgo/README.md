# Celestia IBC relaying guide by IBC-Go

## Update packages and Install dependencies

~~~
sudo apt update && sudo apt upgrade -y
sudo apt install curl build-essential git wget jq make gcc tmux pkg-config libssl-dev libleveldb-dev tar -y
~~~

## Install Go

~~~
cd $HOME
! [ -x "$(command -v go)" ] && {
VER="1.21.3"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"
[ ! -f ~/.bash_profile ] && touch ~/.bash_profile
echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
source $HOME/.bash_profile
}
[ ! -d ~/go/bin ] && mkdir -p ~/go/bin
~~~

Install IBC-Go
~~~
cd $HOME
rm -rf relayer
git clone https://github.com/cosmos/relayer && cd relayer
git checkout v2.5.1
make install
~~~

Check version
~~~
rly version
~~~

Initialize the relayer's configuration directory/file.
~~~
rly config init
~~~

To customize the memo for all relaying, use the --memo flag when initializing the configuration.
 
~~~
MEMO="itrocket"
rly config init --memo $MEMO
~~~

Configure the chains you want to relay between
>The rly chains add command fetches chain meta-data from the [chain-registry](https://github.com/cosmos/chain-registry) and adds it to your config file.
~~~
rly chains add testnets/celestiatestnet3 testnets/elystestnet
~~~

Create new keys for the relayer
~~~
rly keys add elystestnet ibc_elystestnet  
rly keys add celestiatestnet3 ibc_celestiatestnet3
~~~

Or import executing keys
~~~
rly keys restore elystestnet ibc_elystestnet "mnemonic words here"
rly keys restore celestiatestnet3 ibc_celestiatestnet3 "mnemonic words here"
~~~












































































## Install Rust and Cargo

~~~
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
~~~

## Install Go

~~~
cd $HOME
! [ -x "$(command -v go)" ] && {
VER="1.21.3"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"
[ ! -f ~/.bash_profile ] && touch ~/.bash_profile
echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
source $HOME/.bash_profile
}
[ ! -d ~/go/bin ] && mkdir -p ~/go/bin
~~~

## Install Hermes via Cargo

~~~
cargo install ibc-relayer-cli --bin hermes --locked
~~~

Check hermes version
~~~
hermes version
~~~

Make the hermes directory, keys and create config.toml and save this config:

~~~
mkdir -p $HOME/.hermes
mkdir -p $HOME/.hermes/keys
cd .hermes
nano config.toml
~~~
