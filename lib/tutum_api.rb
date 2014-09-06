class TutumApi
  attr_reader :headers
  BASE_API_PATH = "https://app.tutum.co/api"
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

  def get(path, args={})
    HttpParty.get(api_path(path), http_headers.merge({ :query => args }))
  end
  def post(path, args={})
    HttpParty.post(api_path(path), http_headers.merge({ :body => args }))
  end
  def patch(path, args={})
    HttpParty.patch(api_path(path), http_headers.merge({ :body => args }))
  end
  def delete(path, args={})
    HttpParty.delete(api_path(path), http_headers.merge({ :query => args }))
  end
end
