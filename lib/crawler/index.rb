require 'vendor/v796'
require 'vendor/okcoin'
require 'vendor/btce'
require 'vendor/bitstamp'
require 'vendor/bitfinex'
require "httparty"

module Crawler
  class << self
    def run
      Btcall.spider_logger.debug "abcde"
      vendors = [V796, Okcoin, Btce, Bitfinex, Bitstamp]
      while true
        vendors.map(&:run)
        sleep Settings.spider_interval
      end
    end
  end
end

