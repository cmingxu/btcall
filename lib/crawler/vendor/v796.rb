module V796
  def self.run
    require 'httparty'
    while true
      json = HTTParty.get "http://api.796.com/v3/futures/ticker.html?type=weekly"
      puts JSON.parse(json)["ticker"]
      sleep 1
    end
  end
end
