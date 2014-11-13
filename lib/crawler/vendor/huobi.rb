module Huobi
  extend Websocket
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

