require 'httparty'
class TutumApi
  attr_reader :headers
  BASE_API_PATH = "https://dashboard.tutum.co/api"
  API_VERSION = "v1"
  def initialize(headers)
    @headers = headers
  end
  def http_headers
    { headers: headers }
  end
  def api_path(path)
    BASE_API_PATH+"/"+API_VERSION + path
  end

  def http_get(path, args={})
    HTTParty.get(api_path(path), http_headers.merge({ :query => args }))
  end
  def http_post(path, args={})
    HTTParty.post(api_path(path), http_headers.merge({ :body => args.to_json }))
  end
  def http_patch(path, args={})
    HTTParty.patch(api_path(path), http_headers.merge({ :body => args.to_json }))
  end
  def http_delete(path, args={})
    HTTParty.delete(api_path(path), http_headers.merge({ :query => args }))
  end
end
