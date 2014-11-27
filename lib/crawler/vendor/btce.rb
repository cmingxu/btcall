module Btce
  extend Http
  extend Utils

  def self.handle(content, options)
    hash = JSON.parse(content)["btc_usd"]
    rate = RmbUsd.usd2rmb_rate(options)
    entry = OpenStruct.new
    entry.high =  (hash["high"].to_f * rate).round(3)
    entry.low  =  (hash["low"].to_f  * rate).round(3)
    entry.buy  =  (hash["buy"].to_f  * rate).round(3)
    entry.sell =  (hash["sell"].to_f * rate).round(3)
    entry.last =  (hash["last"].to_f * rate).round(3)
    entry.vol  =  hash["vol"].to_f
    entry.timestamp = normalize_time(options)

    JSON.dump(entry.to_h)
  end

end

