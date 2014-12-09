# -*- coding: utf-8 -*-
class Tutum

  class Service < Tutum::Base
    # A unique identifier for the service generated automatically on creation
    attr_reader :uuid

    # A unique API endpoint that represents the service
    attr_reader :resource_uri

    # @param raw [Hash] The attributes of this service
    def initialize(raw, cnxn=nil)
      @info         = normalize_response(raw)
      @uuid         = @info[:uuid]
      @resource_uri = @info[:resource_uri]
      @connection   = cnxn if cnxn
    end

    def forget()
      @containers = nil
      super
    end

    # @option state Filter by state. Possible values: Init, Starting, Running,
    #    Partly running, Scaling, Redeploying, Stopping, Stopped, Terminating,
    #    Terminated, Not running
    # @option name         Filter by service name
    # @option unique_name  Filter by unique name
    #
    # @return [Array[Tutum::Service]] list of returned services
    def self.list(options={}, cnxn=nil)
      options[:state] = options[:state].to_s.split.map(&:capitalize).join(' ') if options.include?(:state)
      raws = connection(cnxn).services.list(options)
      raws.map do |raw|
        self.new(raw, cnxn)
      end
    end

    # Get the Service object with the given ID
    def self.get(uuid, cnxn=nil)
      raw = connection(cnxn).services.get(uuid)
      self.new(raw, cnxn)
    end

    # @return [Tutum::Service] the newly-created service
    def self.create(info={}, cnxn=nil)
      raw = connection(cnxn).services.create(info)
      self.new(raw, cnxn)
    end

    # @option target_num_containers The number of containers to scale this service to
    # @option tags                  List of new tags the service will have. This operation replaces the tag list.
    def update(options={})
      connection.services.update(uuid, info).tap{ self.forget }
    end

    # Starts all containers in a stopped or partly running service.
    def start()
      # return true  if started?
      # return false if not startable?
      connection.services.start(uuid).tap{ self.forget }
    end

    # Stops all containers in a running or partly running service.
    def stop()
      # return true  if stopped?
      # return false if not stoppable?
      connection.services.stop(uuid).tap{ self.forget }
    end

    # Redeploys all containers in the service with the current service
    # configuration. It uses the latest version of the image tag configured.
    def redeploy()
      # return false if not redeployable?
      connection.services.redeploy(uuid).tap{ self.forget }
    end

    # Terminate all the containers in a service and the service itself. This is
    # not reversible. All the data stored in all containers of the service will
    # be permanently deleted.
    def terminate()
      # return false if not terminable?
      connection.services.terminate(uuid).tap{ self.forget }
    end

    def containers()
      @containers ||= container_ids.map{|cid| Tutum::Container.get(cid) }
    end

    #
    def logs(uuid)
      connection.services.logs(uuid)
    end

    # A user provided name for the service. This name will be inherited by the
    # service containers and will be used in endpoint URLs, environment variable
    # names, etc.
    def name()                   ; info[:name]                   ; end

    # A unique name automatically assigned based on the user provided name to be
    # used in the endpoint URLs, environment variable names, etc.
    def unique_name()            ; info[:unique_name]            ; end

    # The Docker image name and tag used for the service containers
    def image_name()             ; info[:image_name]             ; end

    # Resource URI of the image (including tag) used for the service containers
    def image_tag()              ; info[:image_tag]              ; end

    # List of ports to be published on the containers of this service (see table
    # Service Port attributes below)
    def ports()                  ; info[:container_ports]        ; end

    # The date and time of the last deployment of the service (if applicable,
    # null otherwise)
    def deployed_at()      ; Time.parse(info[:deployed_datetime]) rescue nil  ; end

    # The date and time of the last start operation on the service (if
    # applicable, null otherwise)
    def started_at()       ; info[:started_datetime]       ; end

    # The date and time of the last stop operation on the service (if
    # applicable, null otherwise)
    def stopped_at()       ; info[:stopped_datetime]       ; end

    # The date and time of the terminate operation on the service (if
    # applicable, null otherwise)
    def destroyed_at()     ; info[:destroyed_datetime]     ; end

    # Entrypoint to be set on the containers launched as part of the service,
    # which will override the image entrypoint
    def entrypoint()             ; info[:entrypoint]             ; end

    # Run command to be set on the containers launched as part of the service,
    # which will override the image run command
    def run_command()            ; info[:run_command]            ; end

    # Whether to start the containers with Docker's privileged flag set or not,
    # which allows containers to access all devices on the host among other
    # things (see Runtime privilege for more information)
    def privileged()             ; info[:privileged]             ; end

    # The relative CPU priority of the containers of the service (see Runtime
    # Constraints on CPU and Memory for more information)
    def cpu_shares()             ; info[:cpu_shares]             ; end

    # The memory limit of the containers of the service in MB (see Runtime
    # Constraints on CPU and Memory for more information)
    def memory()                 ; info[:memory]                 ; end

    # Whether to terminate the containers of the service automatically if they
    # stop (see Autodestroy for more information)
    def autodestroy()            ; info[:autodestroy]            ; end

    # Whether to restart the containers of the service automatically if they
    # stop (see Crash recovery for more information)
    def autorestart()            ; info[:autorestart]            ; end

    # List of resource URIs of the Action objects that apply to the service
    # (requires extended info to be fetched)
    def actions()             ; ext_info[:actions]             ; end

    # A list of volume bindings that the service has mounted (see table Service
    # binding attributes below)
    # (requires extended info to be fetched)
    def bindings()            ; ext_info[:bindings]            ; end

    # List of user-defined environment variables to set on the containers of the
    # service, which will override the image environment variables (see table
    # Service Environment Variable attributes below)
    # (requires extended info to be fetched)
    def container_envvars()   ; ext_info[:container_envvars]   ; end
    def envs() container_envvars() ;  end

    # List of resource URIs of the containers launched as part of the service
    # (requires extended info to be fetched)
    def container_ids()       ; ext_info[:containers]          ; end

    # List of environment variables that would be exposed in the containers if
    # they are linked to this service
    # (requires extended info to be fetched)
    def link_variables()      ; ext_info[:link_variables]      ; end

    # A list of services that are linked to this one (see table Related services
    # attributes below)
    # (requires extended info to be fetched)
    def linked_from_service() ; ext_info[:linked_from_service] ; end
    def links_from() linked_from_service() ; end

    # A list of services that the service is linked to (see table Related
    # services attributes below)
    # (requires extended info to be fetched)
    def linked_to_service()   ; ext_info[:linked_to_service]   ; end
    def links() linked_to_service() ; end

    # List of Tutum roles asigned to this service (see Service links for more
    # information)
    # (requires extended info to be fetched)
    def roles()               ; ext_info[:roles]               ; end

    # List of tags to be used to deploy the service (see Tags for more information)
    # (requires extended info to be fetched)
    def tags()                ; ext_info[:tags]                ; end

    # Whether the containers for this service should be deployed in sequence,
    # linking each of them to the previous containers (see Service scaling for
    # more information)
    def sequential_deployment()  ; info[:sequential_deployment]  ; end

    # ???
    def deployment_strategy()    ; info[:deployment_strategy]    ; end

    # The actual number of containers deployed for the service
    def current_num_containers() ; info[:current_num_containers] ; end

    # The actual number of containers deployed for the service in Running state
    def running_num_containers() ; info[:running_num_containers] ; end

    # The actual number of containers deployed for the service in Stopped state
    def stopped_num_containers() ; info[:stopped_num_containers] ; end

    # The requested number of containers to deploy for the service
    def target_num_containers()  ; info[:target_num_containers]  ; end

    # The state of the service:
    #
    # * :running           All containers for the service are deployed and running.
    #                      Possible actions in this state: stop, redeploy, terminate.
    # * :partly            One or more containers of the service are deployed and running.
    #                      Possible actions in this state: stop, redeploy, terminate.
    # * :init              The service has been created and has no deployed containers yet.
    #                      Possible actions in this state: start, terminate.
    # * :stopped           All containers for the service are stopped.
    #                      Possible actions in this state: start, redeploy, terminate.
    # * :not_running       There are no containers to be deployed for this service.
    #                      Possible actions in this state: terminate.
    # * :starting          All containers for the service are either starting or already running.
    #                      No actions allowed in this state.
    # * :stopping          All containers for the service are either stopping or already stopped.
    #                      No actions allowed in this state.
    # * :redeploying       The service is redeploying all its containers with the updated configuration.
    #                      No actions allowed in this state.
    # * :scaling           The service is either deploying new containers or destroying existing ones responding to a scaling request.
    #                      No actions allowed in this state.
    # * :terminating       All containers for the service are either being terminated or already terminated.
    #                      No actions allowed in this state.
    # * :terminated        The service and all its containers have been terminated.
    #                      No actions allowed in this state.
    #
    def state()
      info[:state]
    end

    STARTABLE_STATES  = [                     :init, :stopped ].to_set.freeze                        unless defined?(STARTABLE_STATES)
    REDEPABLE_STATES  = [ :running,  :partly,        :stopped ].to_set.freeze                        unless defined?(REDEPABLE_STATES)
    STOPPABLE_STATES  = [ :running,  :partly,                 ].to_set.freeze                        unless defined?(STOPPABLE_STATES)
    TERMINABLE_STATES = [ :running,  :partly, :init, :stopped, :not_running,  ].to_set.freeze        unless defined?(TERMINABLE_STATES)
    #
    TRANSITION_STATES = [ :starting, :stopping, :redeploying, :scaling, :terminating ].to_set.freeze unless defined?(TRANSITION_STATES)
    ABSENT_STATES     = [ :terminating, :terminated ].to_set.freeze                                  unless defined?(ABSENT_STATES)
    #
    def startable?()    STARTABLE_STATES.include?(state) ; end
    def redeployable?() REDEPABLE_STATES.include?(state) ; end
    def stoppable?()    STOPPABLE_STATES.include?(state) ; end
    def terminable?()   TERMINABLE_STATES.include?(state) ; end
    #
    def running?() state == :running ; end
    def stopped?() state == :stopped ; end
    def absent?()  ABSENT_STATES.include?(state) ; end
    def exists?()  not absent? ; end

    def normalize_response(raw)
      raw = super(raw)
      #
      raw[:linked_to_service]   = Tutum::LinkSpec.receive_list(raw[:linked_to_service])   if raw.include?(:linked_to_service)
      raw[:linked_from_service] = Tutum::LinkSpec.receive_list(raw[:linked_from_service]) if raw.include?(:linked_from_service)
      raw[:bindings]            = Tutum::BindSpec.receive_list(raw[:bindings])            if raw.include?(:bindings)
      raw[:container_ports]     = Tutum::PortSpec.receive_list(raw[:container_ports])     if raw.include?(:container_ports)
      raw
    end

    # def to_s
    #   str = []
    #   str << '#<' << self.class.name
    #   [:name, :unique_name, :image_name, ]
    # end

  end
end
