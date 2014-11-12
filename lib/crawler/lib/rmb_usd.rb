module RmbUsd
  def self.run(options)
    while true
      res = HTTParty.get options[:entry_point]
      options[:redis].set(options[:rmb2usd_rate_key], (1/res["query"]["results"]["rate"]["Rate"].to_f).round(3))
      sleep options[:rmbusd_rate_interval]
    end
  end

  def self.usd2rmb_rate(options)
    options[:redis].get(options[:rmb2usd_rate_key]).to_f.round(3)
  end
end
