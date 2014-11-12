#!/usr/bin/env ruby

require "httparty"
require 'faye/websocket'
require 'eventmachine'
require 'httparty'
require 'logger'
require 'fileutils'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'lib/http'
require 'lib/websocket'
require 'vendor/v796'
require 'vendor/okcoin'
require 'vendor/btce'
require 'vendor/bitstamp'
require 'vendor/bitfinex'
require 'vendor/huobi'


module Crawler
  class << self
    def run
      vendors = {
        V796: "http://api.796.com/v3/futures/ticker.html?type=weekly",
        Okcoin: "wss://real.okcoin.cn:10440/websocket/okcoinapi",
        Btce: "https://btc-e.com/api/3/ticker/btc_usd",
        Huobi: "hq.huobi.com:80",
        Bitfinex: "https://api.bitfinex.com/v1/pubticker/btcusd",
        Bitstamp: "https://www.bitstamp.net/api/ticker/"
      }
      options = {
        interval: 5,
        timeout: 3
      }

      vendors.each do |vendor, entry|
        pid = Process.fork do
          options[:initial_handshake] = "{'event':'addChannel','channel':'ok_btccny_ticker'}" if vendor.to_s == "Okcoin"
          $0 = "cralwer_#{vendor}"
          options[:entry_point] = entry
          options[:logger] = Logger.new("/tmp/btcall/#{vendor}.log")
          Kernel.const_get(vendor).send :run, options
        end

        pid_file_name = "/tmp/btcall/#{vendor}.pid"
        FileUtils.rm_f pid_file_name if File.exists?(pid_file_name)
        pid_file = File.open(pid_file_name, "w")
        pid_file.write(pid)
        pid_file.close
      end

    end
  end
end

Crawler.run
