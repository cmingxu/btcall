module Bitfinex
  def self.run
    require 'httparty'
    while true
      json = HTTParty.get "https://api.bitfinex.com/v1/pubticker/btcusd"
      puts JSON.parse(json.body)
      sleep 1
    end
  end
end
