# -*- coding: utf-8 -*-
class Tutum
  class Node < Tutum::Base
    # A unique identifier for the node generated automatically on creation
    attr_reader :uuid

    # A unique API endpoint that represents the node
    attr_reader :resource_uri

    def forget()
      @node_cluster = nil
      super
    end

    # ===========================================================================
    #
    # Fields
    #

    # A list of resource URIs of the Action objects
    def actions()            ; info[:actions]            ; end

    # The resource URI of the node type used
    def node_type()          ; info[:node_type]          ; end

    # List of tags to identify when deploying services
    def tags()               ; info[:tags]               ; end

    # The resource URI of the region where deployed
    def region()             ; info[:region]             ; end

    # The date and time when deployed
    def deployed_at()        ; info_time(:deployed_datetime)  ; end

    # The date and time when terminated (if applicable)
    def destroyed_at()       ; info_time(:destroyed_datetime) ; end


    # Date and time of the last time the node was contacted by Tutum
    def last_seen_at()       ; info_time(:last_seen)     ; end

    # An automatically generated FQDN for the node. Containers deployed on this node will inherit this FQDN.
    def external_fqdn()      ; info[:external_fqdn]      ; end

    # The resouce URI of the node cluster to which this node belongs to (if applicable)
    def node_cluster_id()    ; info[:node_cluster]       ; end

    # Docker's execution driver used in the node
    def docker_execdriver()  ; info[:docker_execdriver]  ; end

    # Docker's storage driver used in the node
    def docker_graphdriver() ; info[:docker_graphdriver] ; end

    # Docker's version used in the node
    def docker_version()     ; info[:docker_version]     ; end

    # The public IP allocated to the node
    def public_ip()          ; info[:public_ip]          ; end

    # ===========================================================================
    #
    # Relations
    #

    def node_cluster
      @node_cluster ||= _get_node_cluster(node_cluster_id)
    end

    # ===========================================================================
    #
    # Actions
    #

    # @option state Filter by state. Possible values: Init, Deploying,
    #     Provisioning, Deployed, Terminating, Terminated
    # @option name         Filter by node cluster name
    # @option region       Filter by region (resource URI)
    # @option node_type    Filter by node type (resource URI)
    #
    # @return [Array[Tutum::Service]] list of returned nodes
    def self.list(options={}, cnxn=nil)
      options[:state] = tutumize_state(options[:state]) if options[:state]
      resp = connection(cnxn).nodes.list(options)
      resp.nil? || resp['objects'].nil? and raise "Unreadable response: #{resp}"
      resp['objects'].map do |raw|
        self.new(raw, cnxn)
      end
    end

    # Get the Node object with the given ID
    def self.get(uuid, cnxn=nil)
      raw = connection(cnxn).nodes.get(uuid)
      self.new(raw, cnxn)
    end

    # options: name, node_type, region, target_num_nodes, tags
    #
    # @return [Tutum::Node] the newly-created node
    def self.create(info={}, cnxn=nil)
      raw = connection(cnxn).nodes.create(info)
      self.new(raw, cnxn)
    end

    # Starts all containers in a stopped or partly running node.
    def deploy()
      connection.nodes.deploy(uuid).tap{ self.forget }
    end

    # Terminate all the containers in a node and the node itself. This is
    # not reversible. All the data stored in all containers of the node will
    # be permanently deleted.
    def terminate()
      connection.nodes.terminate(uuid).tap{ self.forget }
    end

    # ===========================================================================
    #
    # State
    #

    # init             The node has been created and has not been deployed yet.
    #                    Possible actions in this state: deploy, terminate.
    # deployed         The node is deployed and provisioned and is ready to deploy containers.
    #                    Possible actions in this state: terminate.
    # deploying        The node is being deployed in the cloud provider.
    #                    No actions allowed in this state.
    # provisioning     Our agent is being installed and configured on the node.
    #                    No actions allowed in this state.
    # terminating      The node is being terminated in the cloud provider.
    #                    No actions allowed in this state.
    # terminated       The node has been terminated and is no longer present in the cloud provider.
    #                    No actions allowed in this state.
    #
    DEPLOYABLE_STATES = [             :init,                      ].to_set.freeze unless defined?(DEPLOYABLE_STATES)
    TERMINABLE_STATES = [ :deployed,  :init,                      ].to_set.freeze unless defined?(TERMINABLE_STATES)
    #
    TRANSITION_STATES = [ :deploying, :provisioning, :terminating ].to_set.freeze unless defined?(TRANSITION_STATES)
    ABSENT_STATES     = [ :terminating, :terminated               ].to_set.freeze          unless defined?(ABSENT_STATES)
    DOWN_STATES       = [ :terminating, :terminated, :init        ].to_set.freeze unless defined?(DOWN_STATES)
    #
    def deployable?() DEPLOYABLE_STATES.include?(state) ; end
    def terminable?() TERMINABLE_STATES.include?(state) ; end
    def deployed?()   state == :deployed ;  end
    #
    def up?()         deployed?                         ; end
    def down?()       DOWN_STATES.include?(state)       ; end
    def absent?()     ABSENT_STATES.include?(state)     ; end
    def exists?()     not absent?                       ; end
  end
end
