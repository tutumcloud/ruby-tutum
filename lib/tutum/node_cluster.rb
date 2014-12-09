class Tutum
  class NodeCluster < Tutum::Base
    # A unique identifier for the node cluster generated automatically on creation
    attr_reader :uuid

    # A unique API endpoint that represents the node cluster
    attr_reader :resource_uri

    def forget()
      @node = nil
      super
    end

    # ===========================================================================
    #
    # Fields
    #

    # A user provided name for the node cluster
    def name()               ; info[:name]               ; end

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

    # A list of resource URIs of the Node objects on the node cluster
    def node_ids()           ; ext_info[:nodes]          ; end

    # The desired number of nodes for the node cluster
    def target_num_nodes()   ; info[:target_num_nodes]   ; end

    # The actual number of nodes in the node cluster. This may differ from target_num_nodes if the node cluster is being deployed or scaled
    def current_num_nodes()  ; info[:current_num_nodes]  ; end

    # ===========================================================================
    #
    # Relations
    #

    def nodes
      @nodes ||= node_ids.map{|id| _get_node(id) }
    end

    # ===========================================================================
    #
    # Actions
    #

    # @option state Filter by state. Possible values: Init, Deploying, Deployed,
    #    Partly deployed, Scaling, Terminating, Terminated, Empty cluster
    # @option name         Filter by node cluster name
    # @option region       Filter by region (resource URI)
    # @option node_type    Filter by node type (resource URI)
    #
    # @return [Array[Tutum::Service]] list of returned node_clusters
    def self.list(options={}, cnxn=nil)
      options[:state] = tutumize_state(options[:state]) if options[:state]
      resp = connection(cnxn).node_clusters.list(options)
      resp.nil? || resp['objects'].nil? and raise "Unreadable response: #{resp}"
      resp['objects'].map do |raw|
        self.new(raw, cnxn)
      end
    end

    # Get the Node_Cluster object with the given ID
    def self.get(uuid, cnxn=nil)
      raw = connection(cnxn).node_clusters.get(uuid)
      self.new(raw, cnxn)
    end

    # options: name, node_type, region, target_num_nodes, tags
    #
    # @return [Tutum::Node_Cluster] the newly-created node_cluster
    def self.create(info={}, cnxn=nil)
      raw = connection(cnxn).node_clusters.create(info)
      self.new(raw, cnxn)
    end

    # Starts all containers in a stopped or partly running node_cluster.
    def deploy()
      connection.node_clusters.deploy(uuid).tap{ self.forget }
    end

    # Terminate all the containers in a node_cluster and the node_cluster itself. This is
    # not reversible. All the data stored in all containers of the node_cluster will
    # be permanently deleted.
    def terminate()
      connection.node_clusters.terminate(uuid).tap{ self.forget }
    end

    # ===========================================================================
    #
    # State
    #

    # init             The node cluster has been created and has no deployed containers yet.
    #                    Possible actions in this state: deploy, terminate.
    # deployed         All nodes in the cluster are deployed and provisioned.
    #                    Possible actions in this state: terminate.
    # partly           One or more nodes of the cluster are deployed and running.
    #                    Possible actions in this state: terminate.
    # empty           There are no nodes deployed in this cluster.
    #                    Possible actions in this state: terminate.
    # deploying        All nodes in the cluster are either deployed or being deployed.
    #                    No actions allowed in this state.
    # scaling          The cluster is either deploying new nodes or terminating existing ones responding to a scaling request.
    #                    No actions allowed in this state.
    # terminating      All nodes in the cluster are either being terminated or already terminated.
    #                    No actions allowed in this state.
    # terminated       The node cluster and all its nodes have been terminated.
    #                    No actions allowed in this state.
    def state()
      info[:state]
    end

    DEPLOYABLE_STATES = [             :init,                 ].to_set.freeze unless defined?(DEPLOYABLE_STATES)
    TERMINABLE_STATES = [ :deployed,  :init, :partly, :empty ].to_set.freeze unless defined?(TERMINABLE_STATES)
    #
    TRANSITION_STATES = [ :deploying, :scaling, :terminating ].to_set.freeze unless defined?(TRANSITION_STATES)
    ABSENT_STATES     = [ :terminating, :terminated          ].to_set.freeze          unless defined?(ABSENT_STATES)
    #
    def deployable?() DEPLOYABLE_STATES.include?(state)  ; end
    def terminable?() TERMINABLE_STATES.include?(state)  ; end
    def deployed?()   state == :deployed ;  end
    #
    def up?()         deployed?                          ; end
    def down?()       absent?   || (state == :init)      ; end
    def absent?()     ABSENT_STATES.include?(state)      ; end
    def exists?()     not absent?                        ; end


    # ===========================================================================
    #
    # Mechanics
    #

    def self._get(uuid, cnxn=nil)
      connection(cnxn).node_clusters.get(uuid)
    end

  end
end
