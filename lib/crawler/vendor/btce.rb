module Btce
  extend Http
  def self.run(options)
    craw(options) do |content|
      puts content
    end
  end
end

