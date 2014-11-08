module Bitstamp
  def self.run
    require 'httparty'
    while true
      json = HTTParty.get "https://www.bitstamp.net/api/ticker/"
      puts JSON.parse(json.body)
      sleep 1
    end
  end
end
