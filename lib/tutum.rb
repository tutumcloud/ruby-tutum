require_relative './tutum_api'

require_relative './tutum_actions'
require_relative './tutum_containers'
require_relative './tutum_node_clusters'
require_relative './tutum_node_types'
require_relative './tutum_nodes'
require_relative './tutum_providers'
require_relative './tutum_regions'
require_relative './tutum_services'

class Tutum
  attr_reader :username, :api_key

  def initialize(username, api_key)
    @username = username
    @api_key = api_key
  end

  def headers
    {
      'Authorization' => "ApiKey #{@username}:#{@api_key}",
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  def actions
    @actions ||= TutumActions.new(headers)
  end

  def containers
    @containers ||= TutumContainers.new(headers)
  end

  def images
    @images ||= TutumImages.new(headers)
  end

  def node_clusters
    @node_clusters ||= TutumNodeClusters.new(headers)
  end

  def node_types
    @node_types ||= TutumNodeTypes.new(headers)
  end

  def nodes
    @nodes ||= TutumNodes.new(headers)
  end

  def providers
    @providers ||= TutumProviders.new(headers)
  end

  def regions
    @regions ||= TutumRegions.new(headers)
  end

  def services
    @services ||= TutumServices.new(headers)
  end
end
