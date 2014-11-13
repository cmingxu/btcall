#!/usr/bin/env ruby

require "httparty"
require "redis"
require 'faye/websocket'
require 'eventmachine'
require 'logger'
require 'fileutils'
require "ostruct"

class OpenStuct; def to_json; table.to_json; end; end

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'lib/http'
require 'lib/websocket'
require 'lib/rmb_usd'
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
        RmbUsd: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22CNYUSD%22)&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys",
        V796: "http://api.796.com/v3/futures/ticker.html?type=weekly",
        Okcoin: "wss://real.okcoin.cn:10440/websocket/okcoinapi",
        Btce: "https://btc-e.com/api/3/ticker/btc_usd",
        Huobi: "http://market.huobi.com/staticmarket/ticker_btc_json.js",
        Bitfinex: "https://api.bitfinex.com/v1/pubticker/btcusd",
        Bitstamp: "https://www.bitstamp.net/api/ticker/"
      }
      options = {
        interval: 5,
        timeout: 5,
        rmb2usd_rate_key: "rmb2usd",
        rmbusd_rate_interval: 5 * 60
      }

      vendors.each do |vendor, entry|
        pid = Process.fork do
          options[:redis] = Redis.new
          options[:redis_key] = "data_list_#{vendor.downcase}"
          options[:initial_handshake] = "{'event':'addChannel','channel':'ok_btccny_ticker'}" if vendor.to_s == "Okcoin"
          options[:initial_handshake] = '{"symbolId":"btccny","version":1,"msgType":"reqMarketDepthTop","requestIndex":1405131204513}' if vendor.to_s == "Huobi"
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
