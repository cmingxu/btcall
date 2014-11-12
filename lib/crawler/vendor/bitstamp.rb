module Bitstamp
  extend Websocket
  def self.run(options)
    craw(options) do |content|
      puts content
    end
  end
end
