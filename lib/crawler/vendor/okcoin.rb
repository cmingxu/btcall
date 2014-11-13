module Okcoin
  extend Websocket
  #[{ "channel":"ok_btccny_ticker","data":{"buy":"2882.92","high":"2977.9","last":"2883.84","low":"2310.97","sell":"2883.84","timestamp":"1415868558640","vol":"571,322.02"}}]
  @last_data_received_at = Time.now
  def self.run(options)
    craw(options) do |content|
      # make sure not persist date too frequently
      if Time.now - @last_data_received_at > options[:interval]
        options[:redis].rpush options[:redis_key], handle(content, options)
        @last_data_received_at = Time.now
      end
    end
  end

  def self.handle(content, options)
    hash = JSON.parse(content).first["data"]
    entry = OpenStruct.new
    entry.high =  hash["high"]
    entry.low  =  hash["low"]
    entry.buy  =  hash["buy"]
    entry.sell =  hash["sell"]
    entry.last =  hash["last"]
    entry.vol  =  hash["vol"]
    entry.timestamp = hash["timestamp"].to_i / 1000

    JSON.dump(entry.to_h)
  end
end
