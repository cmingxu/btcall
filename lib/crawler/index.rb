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
require 'lib/utils'
require 'lib/websocket'
require 'lib/rmb_usd'
require 'vendor/v796'
require 'vendor/okcoin'
require 'vendor/btce'
require 'vendor/bitstamp'
require 'vendor/bitfinex'
require 'vendor/huobi'
require 'vendor/data_filter'


module Crawler
  class << self
    def run
      vendors = {
        RmbUsd: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22CNYUSD%22)&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys",
        V796: "http://api.796.com/v3/futures/ticker.html?type=weekly",
        Okcoin: "https://www.okcoin.cn/api/v1/ticker.do?symbol=btc_cny",
        Btce: "https://btc-e.com/api/3/ticker/btc_usd",
        Huobi: "http://market.huobi.com/staticmarket/ticker_btc_json.js",
        Bitfinex: "https://api.bitfinex.com/v1/pubticker/btcusd",
        Bitstamp: "https://www.bitstamp.net/api/ticker/",
        DataFilter: "placeholder"
      }
      options = {
        interval: 15,
        timeout: 30,
        rmb2usd_rate_key: "rmb2usd",
        rmbusd_rate_interval: 5 * 60,
        max_list_len: 3 * 24 * 3600,
        vendors_list: %w(v796 okcoin btce huobi bitfinex bitstamp)
      }

      vendors.each do |vendor, entry|
        pid = Process.fork do
          options[:redis] = Redis.new
          options[:redis_key_prefix] = "data_list_"
          options[:redis_key] = "#{options[:redis_key_prefix]}#{vendor.downcase}"
          options[:initial_handshake] = "{'event':'addChannel','channel':'ok_btccny_ticker'}" if vendor.to_s == "Okcoin"
          options[:initial_handshake] = '{"symbolId":"btccny","version":1,"msgType":"reqMarketDepthTop","requestIndex":1405131204513}' if vendor.to_s == "Huobi"
          $0 = "cralwer_#{vendor}"
          options[:entry_point] = entry
          options[:logger] = Logger.new("/tmp/btcall/#{vendor}.log")
          options[:data_filter_interval] = 3
          options[:filtered_data_key] = "filtered_data"
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

