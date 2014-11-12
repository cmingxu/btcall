module Huobi
  extend Http
  def self.run(options)
    craw(options) do |body|
      puts body
    end
  end
end

