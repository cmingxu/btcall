module Utils
  def run(options)
    craw(options) do |content|
      data = handle(content, options)
      if data_valid(data)
        options[:redis].lpush options[:redis_key], data
        options[:redis].ltrim options[:redis_key], 0, options[:max_list_len]
      end
    end
  end

  def data_valid(data)
    data = OpenStruct.new(JSON.parse(data))
    return false if data.high.to_i.floor.zero?
    return false if data.low.to_i.floor.zero?
    return false if data.buy.to_i.floor.zero?
    return false if data.sell.to_i.floor.zero?
    return false if data.last.to_i.floor.zero?

    true
  end

  def normalize_time(options)
    Time.now.to_i #/ (options[:interval]) * options[:interval]
  end
end
