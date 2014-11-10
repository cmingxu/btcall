#!/usr/bin/env ruby

require "httparty"
require 'faye/websocket'
require 'eventmachine'
require 'httparty'

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), "vendor")))

require 'v796'
require 'okcoin'
require 'btce'
require 'bitstamp'
require 'bitfinex'
require 'huobi'


module Crawler
  class << self
    def run
      vendors = {
        V796: "http://api.796.com/v3/futures/ticker.html?type=weekly",
        Okcoin: "wss://real.okcoin.cn:10440/websocket/okcoinap",
        Btce: "https://btc-e.com/api/3/ticker/btc_usd",
        Bitstamp: "hq.huobi.com:80",
        Bitfinex: "https://api.bitfinex.com/v1/pubticker/btcusd",
        Huobi: "https://www.bitstamp.net/api/ticker/"
      }
      options = {
        interval: 5,
        logger_path: "/tmp/btcall",
        timeout: 3
      }

      vendors.each do |vendor, entry|
        Process.fork do
          Process.daemonize
          $0 = "cralwer_#{vendor}"
          options[:entry_point] = entry
          options[:logger] = Logger.new()
        end
      end


    end
  end
end

Crawler.run
