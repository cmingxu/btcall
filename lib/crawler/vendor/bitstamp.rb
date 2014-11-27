module Bitstamp
  extend Http
  extend Utils

  def self.handle(content, options)
    hash = JSON.parse(content)
    rate = RmbUsd.usd2rmb_rate(options)
    entry = OpenStruct.new
    entry.high =  (hash["high"].to_f * rate).round(3)
    entry.low  =  (hash["low"].to_f  * rate).round(3)
    entry.buy  =  (hash["bid"].to_f  * rate).round(3)
    entry.sell =  (hash["ask"].to_f * rate).round(3)
    entry.last =  (hash["last"].to_f * rate).round(3)
    entry.vol  =  hash["volume"].to_i
    entry.timestamp = normalize_time(options)

    JSON.dump(entry.to_h)
  end
end
