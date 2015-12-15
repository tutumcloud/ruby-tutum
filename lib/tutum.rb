require 'base64'

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
  attr_reader :username, :api_key, :tutum_auth, :json_opts

  def initialize(*options)
    @options = extract_options! options
    @username = @options[:username]
    @api_key = @options[:api_key]
    @tutum_auth = @options[:tutum_auth]
    @json_opts = @options[:json_opts]
  end

  def headers
    {
      'Authorization' => authorization_header,
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  def actions
    @actions ||= TutumActions.new(headers, @json_opts)
  end

  def containers
    @containers ||= TutumContainers.new(headers, @json_opts)
  end

  def images
    @images ||= TutumImages.new(headers, @json_opts)
  end

  def node_clusters
    @node_clusters ||= TutumNodeClusters.new(headers, @json_opts)
  end

  def node_types
    @node_types ||= TutumNodeTypes.new(headers, @json_opts)
  end

  def nodes
    @nodes ||= TutumNodes.new(headers, @json_opts)
  end

  def providers
    @providers ||= TutumProviders.new(headers, @json_opts)
  end

  def regions
    @regions ||= TutumRegions.new(headers, @json_opts)
  end

  def services
    @services ||= TutumServices.new(headers, @json_opts)
  end

  def stacks
    @stacks ||= TutumStacks.new(headers, @json_opts)
  end

  private

  def authorization_header
    @tutum_auth ? @tutum_auth : "Basic #{Base64.strict_encode64(@username + ':' + @api_key)}"
  end

  def extract_options!(args)
    options = {}
    if args[0].class == String
      options[:username] = args[0]
      options[:api_key] = args[1]
      options[:json_opts] = args[2]
    else
      options = args[0]
    end
    options
  end
end
