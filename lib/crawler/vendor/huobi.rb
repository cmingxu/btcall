module Huobi
  def self.run
    require 'faye/websocket'
    require 'eventmachine'

    EM.run {
      ws = Faye::WebSocket::Client.new('hq.huobi.com:80')

      ws.on :open do |event|
        p [:open]
      end


      ws.on :message do |event|
        p [:message, event.data]
      end

      ws.on :close do |event|
        p [:close, event.code, event.reason]
        ws = nil
      end
    }

  end
end

