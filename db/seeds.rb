User.create!([
  {gatekeeper_id: nil, email: "cmditch@gmail.com", encrypted_password: "$2a$11$/HBLj45A1cZM6Y1g5XhWROKpvmGkdu/yqNa/X9lSmYtvKDT8K9/Aa", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2016-12-23 03:41:16", last_sign_in_at: "2016-12-23 03:41:16", current_sign_in_ip: "::1", last_sign_in_ip: "::1"}
])
Client.create!([
  {name: "Coury Ditch", gatekeeper_id: 1}
])
Gatekeeper.create!([
  {name: "Denver Rescue Mission"}
])
Transaction.create!([
  {txid: "98e11ac83210d6d16da3efe3f4376a51168f58167ffb5c6b412d7bd4402d4037", sender: ["1Nt6vJjp588Sf44CSW5EhZhmwuEpkmnZEX"], recipient: ["1DkMksWoezeRLQCePjfRESCcEVSuKpLFVk"], amount: 50000, time: "2016-12-23 02:04:07", block_id: 444672, fee: 15460, currency: "btc"}
])
Vendor.create!([
  {name: "7-11"}
])
Wallet.create!([
  {address: "1DkMksWoezeRLQCePjfRESCcEVSuKpLFVk", balance: nil, active: nil, transactor_id: 1, transactor_type: "Client", currency: "btc"},
  {address: "17i9QpYh1hfgTWRgRGSDZQ7wUQUogmj6zp", balance: nil, active: nil, transactor_id: 1, transactor_type: "Vendor", currency: nil}
])
