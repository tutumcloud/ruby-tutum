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


  def expect_200(path, &block)
    response = block.call
    if(response.code != 200)
      raise TutumError.new("#{response.code} received for API call to #{path}")
    end
  end

  def http_get(path, args={})
    expect_200(path) do 
      HTTParty.get(api_path(path), http_headers.merge({ :query => args }))
    end
  end
  def http_post(path, args={})
    expect_200(path) do 
      HTTParty.post(api_path(path), http_headers.merge({ :body => args.to_json }))
    end
  end
  def http_patch(path, args={})
    expect_200(path) do 
      HTTParty.patch(api_path(path), http_headers.merge({ :body => args.to_json }))
    end
  end
  def http_delete(path, args={})
    expect_200(path) do 
      HTTParty.delete(api_path(path), http_headers.merge({ :query => args }))
    end
  end
end
