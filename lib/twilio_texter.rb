require 'dgp_module'

number = '+17204631705'
account_sid = 'AC7eb09bd10053f8ff9ff40236689b3f0c'
auth_token = '4dc14ef4a4f26a83c140b84558fc0323'

# set up a client to talk to the Twilio REST API
@client = Twilio::REST::Client.new account_sid, auth_token

@client.account.messages.create({
    :to => '+13036467752',
    :from => number,
    :body => "Sweet! we can generate the Bitpay pairing code and auto-text it with this nifty service. -- Coury"
    #:body => "BitPay Pairing Code: " + DGP.bitpay_pair,
})