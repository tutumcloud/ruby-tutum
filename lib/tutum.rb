require 'set'
require_relative './tutum_api'

require_relative './tutum_actions'
require_relative './tutum_containers'
require_relative './tutum_node_clusters'
require_relative './tutum_node_types'
require_relative './tutum_nodes'
require_relative './tutum_providers'
require_relative './tutum_regions'
require_relative './tutum_services'
require_relative './tutum_volumes'

require_relative './tutum/base'
require_relative './tutum/spec'
require_relative './tutum/service'
require_relative './tutum/container'
require_relative './tutum/node'
require_relative './tutum/volume'

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

  def self.authenticate!(username, api_key)
    @connection = ::Tutum.new(username, api_key)
  end

  # Used for a globally shared connection; or provide your own
  #
  def self.connection
    @connection or raise "Must call #{self.name}#authenticate! or provide a ::Tutum object."
  end


  def actions
    @actions ||= TutumContainers.new(headers)
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

  def services
    @services ||= TutumServices.new(headers)
  end

  def volumes
    @volumes ||= TutumVolumes.new(headers)
  end

  def vol_groups
    @vol_groups ||= TutumVolGroups.new(headers)
  end


end
