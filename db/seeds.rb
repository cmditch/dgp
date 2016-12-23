User.create!([
  {gatekeeper_id: 1, email: "cmditch@gmail.com", password: "qwerty"}
])
Client.create!([
  {name: "Coury Ditch", gatekeeper_id: 1}
])
Gatekeeper.create!([
  {name: "Denver Rescue Mission"}
])
Vendor.create!([
  {name: "7-11"}
])
Wallet.create!([
  {address: "1DkMksWoezeRLQCePjfRESCcEVSuKpLFVk", balance: nil, active: nil, transactor_id: 1, transactor_type: "Client", currency: "btc"},
  {address: "17i9QpYh1hfgTWRgRGSDZQ7wUQUogmj6zp", balance: nil, active: nil, transactor_id: 1, transactor_type: "Vendor", currency: "btc"}
])
