module Http
  def craw(options)
    begin
      HTTParty.get(options[:entry_point], :timeout => options[:timeout])
    rescue Exception => e
      options[:logger].error "#{e}"
      exit(1)
    end
  end
end
