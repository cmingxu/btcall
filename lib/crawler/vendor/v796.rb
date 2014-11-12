module V796
  extend Http

  def self.run(options)
    craw(options) do |content|
      options[:redis].rpush options[:redis_key], handle(content, options)
    end
  end

  def self.handle(content, options)
    hash = JSON.parse(content)["ticker"]
    rate = RmbUsd.usd2rmb_rate(options)
    entry = OpenStruct.new
    entry.high =  (hash["high"].to_f * rate).round(3)
    entry.low  =  (hash["low"].to_f  * rate).round(3)
    entry.buy  =  (hash["buy"].to_f  * rate).round(3)
    entry.sell =  (hash["sell"].to_f * rate).round(3)
    entry.last =  (hash["last"].to_f * rate).round(3)
    entry.vol  =  (hash["vol"].to_f  * rate).round(3)
    entry.timestamp = Time.now.to_i

    JSON.dump(entry.to_h)
  end

end
