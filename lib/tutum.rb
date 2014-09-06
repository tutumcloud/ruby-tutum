require_relative './tutum_api'
require_relative './tutum_clusters'
require_relative './tutum_containers'
require_relative './tutum_images'

class Tutum
  attr_reader :username, :api_key
  def initialize(username, api_key)
    @username = username
    @api_key = api_key
  end

  def headers
    {
      "Authorization" => "ApiKey #{@username}:#{@api_key}",
      "Accept" => "application/json"
    }
  end

  def containers
    @containers ||= TutumContainers.new(headers)
  end

  def images
    @images ||= TutumImages.new(headers)
  end

  def clusters
    @clusters ||= TutumClusters.new(headers)
  end
end
