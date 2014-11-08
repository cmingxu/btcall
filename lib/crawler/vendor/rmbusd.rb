module Rmbusd
  def self.run
    require 'httparty'
    while true
      json = HTTParty.get "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22CNYUSD%22)&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
      puts JSON.parse(json.body)
      sleep 1
    end
  end
end
