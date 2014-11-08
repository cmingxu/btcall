module Btce
  def self.run
    require 'httparty'
    while true
      json = HTTParty.get "https://btc-e.com/api/3/ticker/btc_usd"
      puts JSON.parse(json)["btc_usd"]
      sleep 1
    end
  end
end

