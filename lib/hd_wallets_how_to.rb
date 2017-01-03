# Thanks to https://ozanyurtseven.wordpress.com/2015/04/29/hierarchical-deterministic-wallets-bip0032bip0044-in-ruby/
# This helped crack the long night of trial and error 1/1/17 - cditch
#
# Verify with online tool: 
# https://github.com/btchip/bip39
#
# gem 'money-tree'
# Implements BIP32 HD Wallet Creation
#
# gem 'bip_mnemonic'
# Helps generate BIP39 compliant seeds to feed BIP32
#
# Expected Results:
# First Two Spending Wallets
# m/44'/0'/0'/0/0  157b6Chf5F6Upqj1FvChZvjjwEuKuWSShm
# m/44'/0'/0'/0/1  1F4xw7q9LSHJRpjRYZZGYeeVVWk8nf9yyp
#
# First Two Change Wallets
# m/44'/0'/0'/1/0  1ERiDn8R7qnqsGsHerKev7XM9nkWoSSFch
# m/44'/0'/0'/1/1  18yXfddYGUJktkuLz8MNRbjjmrXwhLZJw8
#

require 'money-tree'
require 'bip_mnemonic'

answer = { spend: ["157b6Chf5F6Upqj1FvChZvjjwEuKuWSShm", "1F4xw7q9LSHJRpjRYZZGYeeVVWk8nf9yyp"], 
           change: ["1ERiDn8R7qnqsGsHerKev7XM9nkWoSSFch", "18yXfddYGUJktkuLz8MNRbjjmrXwhLZJw8"]
         }
         
result = {spend: [], change: []}

words = "start amused entire check town curtain human clarify police umbrella change uncle"
seed  = BipMnemonic.to_seed(mnemonic: words)
master = MoneyTree::Master.new(seed_hex: seed)

result[:spend] << master.node_for_path("m/44'/0'/0'/0/0").to_address
result[:spend] << master.node_for_path("m/44'/0'/0'/0/1").to_address
result[:change] << master.node_for_path("m/44'/0'/0'/1/0").to_address
result[:change] << master.node_for_path("m/44'/0'/0'/1/1").to_address

answer == result


