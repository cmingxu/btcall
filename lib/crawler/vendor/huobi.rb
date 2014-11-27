module Huobi
  extend Http
  extend Utils

  def self.handle(content, options)
    hash = JSON.parse(content)["ticker"]
    entry = OpenStruct.new
    entry.high =  hash["high"]
    entry.low  =  hash["low"]
    entry.buy  =  hash["buy"]
    entry.sell =  hash["sell"]
    entry.last =  hash["last"]
    entry.vol  =  hash["vol"]
    entry.timestamp = Time.now.to_i

    JSON.dump(entry.to_h)
  end
end

