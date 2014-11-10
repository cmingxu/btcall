module Bitstamp
  def self.run(options)
    while true
      json = HTTParty.get "https://www.bitstamp.net/api/ticker/"
      puts JSON.parse(json.body)
    end
  end
end
