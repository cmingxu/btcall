module Websocket
  def craw(options)
    logger = options[:logger]
    vendor = options[:venddor]
    EM.run {
      ws = Faye::WebSocket::Client.new(options[:entry_point])

      ws.on :open do |event|
        puts options[:initial_handshake]
        ws.send options[:initial_handshake] if options[:initial_handshake]
        logger.debug "#{vendor} open & start to receive messages"
      end


      ws.on :message do |event|
        logger.debug "#{vendor} message received #{event.data}"
        yield event.data if block_given?
      end

      ws.on :close do |event|
        logger.debug "#{vendor} close #{event.code}, #{event.reason}"
        ws = nil
      end
    }

  end
end


