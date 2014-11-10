module Btce
  def self.run
    while true
      json = HTTParty.get "https://btc-e.com/api/3/ticker/btc_usd"
      puts JSON.parse(json)["btc_usd"]
    end
  end
end

