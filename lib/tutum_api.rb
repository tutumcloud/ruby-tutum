require 'rest-client'

class TutumApi
  attr_reader :headers

  BASE_API_PATH = 'https://dashboard.tutum.co/api'
  API_VERSION = 'v1'

  def initialize(headers)
    @headers = headers
  end

  def url(path)
    BASE_API_PATH + '/' + API_VERSION + path
  end

  def http_get(path, params={})
    query =  "?" + params.map { |k,v| "#{k}=#{v}"}.join("&")
    full_path = path
    full_path += query unless params.empty?
    response = execute(method: :get, url: url(path), headers: headers, verify_ssl: false)
    JSON.parse(response)
  end

  def http_post(path, content={})
    response = execute(method: :post, url: url(path), payload: content.to_json, headers: headers, verify_ssl: false)
    JSON.parse(response)
  end

  def http_patch(path, content={})
    response = execute(method: :patch, url: url(path), payload: content.to_json, headers: headers, verify_ssl: false)
    JSON.parse(response)
  end

  def http_delete(path)
    response = execute(method: :delete, url: url(path), headers: headers, verify_ssl: false)
    JSON.parse(response)
  end

  # given '/api/v1/service/c4a02992/' or 'c4a02992', returns just the 'c4a02992' part
  def self.stripped_id(uuid)
    uuid.split('/').last
  end
  def stripped_id(uuid) TutumApi.stripped_id(uuid) ; end

  class ApiException < ::RestClient::ExceptionWithResponse
    def initialize(response = nil, initial_response_code = nil, msg = nil)
      super(response, initial_response_code)
      @message = msg if msg
    end
    def message
      "#{http_body || 'Unexplained Error'} (#{@message || self.class.name})"
    end
    def to_s
      "#{self.class.name}: #{message}"
    end
    def inspect
      to_s
    end
  end

  def execute(query)
    RestClient::Request.execute(query)
  rescue RestClient::Exception => err
    raise ApiException.new(err.response, err.http_code, err.message)
  end
end
