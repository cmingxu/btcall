$redis = Redis.new

$latest_price_key = "filtered_data"

module Kernel
  def current_btc_price
    _, _, current_price = parse_btc_price_structure(get_btc_price_struct)
    current_price
  end

  def current_btc_price_in_int
    _, _, current_price = parse_btc_price_structure(get_btc_price_struct)
    (current_price * 10000 / 100).ceil
  end

  def get_btc_price_struct
    current_price = $redis.lrange $latest_price_key, 0, 0
    raise NoCurrentBtcPriceFound.new if current_price.blank?
    current_price.first
  end

  def parse_btc_price_structure(btc_price_struct)
    timestamp =  btc_price_struct.split("_")[0]
    prices    =  btc_price_struct.split("_")[1].split("|").map(&:to_f)
    avg_price =  prices.sum / prices.length
    [timestamp, prices, avg_price]
  end
end
