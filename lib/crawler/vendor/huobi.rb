module Huobi
  extend Websocket
  def self.run(options)
    craw(options) do |body|
      puts body
    end
  end
end

