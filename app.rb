require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require 'httpclient'
require 'pry'

configure do
  enable :cross_origin
end

class ExpEmail < Sinatra::Base

  options "*" do
    response.headers["Allow"] = "HEAD,POST,OPTIONS"
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"

    200
  end

  post '/' do 

    data = params.select { |key, value| key.to_s.match(/^(email|type)/) }

    client = JSONClient.new
    mailerlite = client.post(
      "https://api.mailerlite.com/api/v2/groups/6953693/subscribers",
      {
        header: {
          "Content-Type" => "application/json; charset=utf-8",
          "X-MailerLite-ApiKey" => "e0eb5160d22beb7700d8e13477a64ae4" 
        },
        body: data
      }
    )
    
     response.headers["Access-Control-Allow-Origin"] = "*"
     mailerlite.status
  end
end

module HTTP
  class Message
    alias original_content content

    def content
      if JSONClient::CONTENT_TYPE_JSON_REGEX =~ content_type
        JSON.parse(original_content)
      else
        original_content
      end
    end
  end
end

class JSONClient < HTTPClient
  CONTENT_TYPE_JSON_REGEX = /(application|text)\/(x-)?json/i
 
  attr_accessor :content_type_json
 
  class JSONRequestHeaderFilter
    attr_accessor :replace
 
    def initialize(client)
      @client = client
      @replace = false
    end
 
    def filter_request(req)
      req.header['content-type'] = @client.content_type_json if @replace
    end
 
    def filter_response(req, res)
      @replace = false
    end
  end
 
  def initialize(*args)
    super
    @header_filter = JSONRequestHeaderFilter.new(self)
    @request_filter << @header_filter
    @content_type_json = 'application/json; charset=utf-8'
  end
 
  def post(uri, *args, &block)
    @header_filter.replace = true
    request(:post, uri, jsonify(argument_to_hash(args, :body, :header, :follow_redirect)), &block)
  end
 
  def put(uri, *args, &block)
    @header_filter.replace = true
    request(:put, uri, jsonify(argument_to_hash(args, :body, :header)), &block)
  end
 
private
 
  def jsonify(hash)
    if hash[:body] && hash[:body].is_a?(Hash)
      hash[:body] = JSON.generate(hash[:body])
    end
    hash
  end
end