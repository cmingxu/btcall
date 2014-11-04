module Okcoin
  def self.run
    require 'faye/websocket'
    require 'eventmachine'

    EM.run {
      ws = Faye::WebSocket::Client.new('wss://real.okcoin.cn:10440/websocket/okcoinapi')

      ws.on :open do |event|
        p [:open]
        ws.send("{'event':'addChannel','channel':'ok_btccny_ticker'}")
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
