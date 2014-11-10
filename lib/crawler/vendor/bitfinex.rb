module Bitfinex
  def self.run(options)
    json = HTTParty.get "https://api.bitfinex.com/v1/pubticker/btcusd"
    puts JSON.parse(json.body)
  end
end
