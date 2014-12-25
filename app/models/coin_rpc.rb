# -*- encoding : utf-8 -*-
require 'net/http'
require 'uri'
require 'json'

class JSONRPCError < RuntimeError; end
class ConnectionRefusedError < StandardError; end
class ConnectionTimeoutError < StandardError; end

class CoinRPC
  class << self
    attr_accessor :url

    def method_missing(name, *args)
      post_body = { 'method' => name, 'params' => args, 'id' => 'jsonrpc' }.to_json
      puts post_body
      Rails.logger.debug "============= RPC Call ================ "
      Rails.logger.debug post_body
      resp = JSON.parse( http_post_request(post_body) )
      raise JSONRPCError, resp['error'] if resp['error']
      result = resp['result']
      result.symbolize_keys! if result.is_a? Hash
      result
    end

    def http_post_request(post_body)
      #uri = URI.parse "http://Ulysseys:YourSuperGreatPasswordNumber_385593@42.96.173.64:8332"
      uri = URI.parse "http://#{Settings.bitcoind.user}:#{Settings.bitcoind.password}@#{Settings.bitcoind.host}:#{Settings.bitcoind.port}"
      http    = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.basic_auth uri.user, uri.password
      request.content_type = 'application/json'
      request.body = post_body
      http.request(request).body
    rescue Errno::ECONNREFUSED => e
      $stderr.puts uri
      $stderr.puts "ECONNREFUSED"
      raise ConnectionRefusedError

    rescue Timeout::Error => e
      $stderr.puts uri
      $stderr.puts "Timeout"
      raise ConnectionTimeoutError
    end

  end

  def self.new_bc_address_for_user(user)
    getnewaddress(user.account_name)
  end

end

