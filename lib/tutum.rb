require_relative './tutum_api'

require_relative './tutum_actions'
require_relative './tutum_containers'
require_relative './tutum_node_clusters'
require_relative './tutum_node_types'
require_relative './tutum_nodes'
require_relative './tutum_providers'
require_relative './tutum_regions'
require_relative './tutum_services'
require_relative './tutum_stacks'

class Tutum
  attr_reader :username, :api_key, :tutum_auth

  def initialize(*options)
    @options = extract_options! options
    @username = @options[:username]
    @api_key = @options[:api_key]
    @tutum_auth = @options[:tutum_auth]
  end

  def headers
    {
      'Authorization' => @tutum_auth ? @tutum_auth : "ApiKey #{@username}:#{@api_key}",
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

  def stacks
    @stacks ||= TutumStacks.new(headers)
  end

  private

  def extract_options!(args)
    options = {}
    if args[0].class == String
      options[:username] = args[0]
      options[:api_key] = args[1]
    else
      options = args[0]
    end
    options
  end
end
