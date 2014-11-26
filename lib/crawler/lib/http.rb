module Http
  def craw(options)
    while true do
      begin_time = Time.now
      begin
        res = HTTParty.get(options[:entry_point], :timeout => options[:timeout])
        options[:logger].debug res.body
        yield res.body if block_given?
      rescue Exception => e
        options[:logger].error "#{e}"
      end
      interval = (options[:interval] - (Time.now - begin_time)) 
      options[:logger].debug interval
      sleep interval < 0 ? 0 : interval
    end
  end
end
