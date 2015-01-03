class WinRate
  HASH_KEY = "buy_win_rate"

  def self.get_buy_win_rates
    time_points = [
      Time.at((Time.now.to_i / 600) * 600 + 1 * 600).strftime("%Y%m%d%H%M"),
      Time.at((Time.now.to_i / 600) * 600 + 2 * 600).strftime("%Y%m%d%H%M"),
      Time.at((Time.now.to_i / 600) * 600 + 3 * 600).strftime("%Y%m%d%H%M"),
      Time.at((Time.now.to_i / 600) * 600 + 4 * 600).strftime("%Y%m%d%H%M"),
      Time.at((Time.now.to_i / 600) * 600 + 5 * 600).strftime("%Y%m%d%H%M"),
      Time.at((Time.now.to_i / 600) * 600 + 6 * 600).strftime("%Y%m%d%H%M")
    ]


    Hash[time_points.zip($redis.pipelined do
      time_points.each do |tp|
        $redis.hget HASH_KEY, tp
      end
    end)]
  end

  def self.set_win_rates(open_at_code, rate)
    $redis.hset HASH_KEY, open_at_code, rate
  end
end
