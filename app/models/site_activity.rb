class SiteActivity
  STREAM_OPEN = "open_stream"
  STREAM_WIN = "win_stream"

  class << self

    def puts_stream_open(bid)
      $redis.lpush(STREAM_OPEN, "#{Time.now.to_i}_用户#{bid.user_id}刚刚开仓@#{rmb_int_to_float(bid.order_price)}")
    end

    def puts_stream_win(maker_open)
      $redis.lpush(STREAM_WIN, "#{Time.now.to_i}_用户#{maker_open.user_id}刚刚盈利@#{btc_int_to_float(maker_open.net_income)}")
    end

    def gets_from_stream_open
      $redis.lrange(STREAM_OPEN, 0, 30)
    end

    def gets_from_stream_win
      $redis.lrange(STREAM_WIN, 0, 30)
    end
  end
end
