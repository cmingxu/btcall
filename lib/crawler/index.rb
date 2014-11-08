#!/usr/bin/env ruby

require "httparty"
require 'faye/websocket'
require 'eventmachine'

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), "vendor")))

puts $LOAD_PATH.first

require 'v796'
require 'okcoin'
require 'btce'
require 'bitstamp'
require 'bitfinex'
require 'huobi'


module Crawler
  class << self
    def run
      #Btcall.spider_logger.debug "abcde"
      #pid = Process.fork { Okcoin.run }
      #pid2 = Process.fork { V796.run }
      #Process.waitall
      #vendors = [V796, Okcoin, Btce, Bitfinex, Bitstamp]
      #while true
      #vendors.map(&:run)
      #sleep Settings.spider_interval
      #end
    end
  end
end

Crawler.run
