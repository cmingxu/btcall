module DataFilter
  def self.run(options)
    while true
      timestamp_to_watch = Time.now.to_i / options[:interval] * options[:interval]
      vals = options[:vendors_list].map do |vendor|
        raw_data = options[:redis].lindex options[:redis_key_prefix] + vendor, 0
        if raw_data  && (os = OpenStruct.new(JSON.parse(raw_data))) && os.timestamp.to_i == timestamp_to_watch
          ((os.buy.to_f + os.sell.to_f) / 2).round(2)
        else
          ""
        end
      end

      if vals.select{|v| Float === v }.length >= 4
        new_value = "#{timestamp_to_watch}_#{vals.join('|')}"
        if (last_node = options[:redis].lindex(options[:filtered_data_key], 0)) && (last_node.split("_")[0].to_s == timestamp_to_watch.to_s)
          options[:redis].lset options[:filtered_data_key], 0, new_value
        else
          options[:redis].lpush options[:filtered_data_key], new_value
        end
      end
      sleep options[:data_filter_interval]
    end
  end
end
