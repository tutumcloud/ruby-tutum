# -*- coding: utf-8 -*-
class Tutum
  class Container < Tutum::Base
    # A unique identifier for the container generated automatically on creation
    attr_reader :uuid

    # A unique API endpoint that represents the container
    attr_reader :resource_uri

    def forget()
      @service = @node = nil
      super
    end

    # ===========================================================================
    #
    # Fields
    #

    # A user provided name for the container (inherited from the service)
    def name()              ; info[:name]                    ; end

    # The resource URI of the service which this container is part of
    def service_id()        ; info[:service]                 ; end

    # The resource URI of the node where this container is running
    def node_id()           ; info[:node]                    ; end

    # The numeric exit code of the container (if applicable, null otherwise)
    def exit_code()         ; info[:exit_code]               ; end

    # A string representation of the exit code of the container (if applicable, null otherwise)
    def exit_code_msg()     ; info[:exit_code_msg]           ; end

    # The external FQDN of the container
    def public_fqdn()       ; info[:public_dns]              ; end

    # A unique name automatically assigned based on the user provided name to be
    # used in the endpoint URLs, environment variable names, etc.
    def unique_name()       ; info[:unique_name]             ; end

    # The Docker image name and tag used
    def image_name()        ; info[:image_name]              ; end

    # Resource URI of the image (including tag) used
    def image_tag()         ; info[:image_tag]               ; end

    # List of published ports
    def ports()             ; info[:container_ports]         ; end

    # The date and time of the last deployment (if any, null otherwise)
    def deployed_at()       ; info_time(:deployed_datetime)  ; end

    # The date and time of the last start operation (if any, nil otherwise)
    def started_at()        ; info_time(:started_datetime)   ; end

    # The date and time of the last stop operation (if any, nil otherwise)
    def stopped_at()        ; info_time(:stopped_datetime)   ; end

    # The date and time of the terminate operation (if any, nil otherwise)
    def destroyed_at()      ; info_time(:destroyed_datetime) ; end

    # Entrypoint used on launch
    def entrypoint()        ; info[:entrypoint]              ; end

    # Run command used on launch
    def run_command()       ; info[:run_command]             ; end

    # Whether Docker’s privileged is flag set.  Privileged containers may access
    # all devices on the host, among other things
    def privileged()        ; info[:privileged]              ; end

    # The relative CPU priority
    def cpu_shares()        ; info[:cpu_shares]              ; end

    # The memory limit in MB
    def memory()            ; info[:memory]                  ; end

    # Whether to restart automatically if it stops
    def autodestroy()       ; info[:autodestroy]             ; end

    # Whether to terminate automatically if it stops
    def autorestart()       ; info[:autorestart]             ; end

    # List of resource URIs of the Action objects that apply (requires extended
    # info to be fetched)
    def actions()           ; ext_info[:actions]             ; end

    # A list of volume bindings mounted (requires extended info to be fetched)
    def bindings()          ; ext_info[:bindings]            ; end

    # List of user-defined environment variables set (requires extended info to
    # be fetched)
    def container_envvars() ; ext_info[:container_envvars]   ; end
    def envs() container_envvars() end

    # List of Tutum roles assigned (requires extended info to be fetched)
    def roles()             ; ext_info[:roles]               ; end

    # ===========================================================================
    #
    # Relations
    #

    def service()
      @service ||= _get_service(service_id)
    end

    def node()
      @node    ||= _get_node(node_id)
    end

    # ===========================================================================
    #
    # Actions
    #

    # @option state Filter by state. Possible values: Init, Starting, Running,
    #    Partly running, Scaling, Redeploying, Stopping, Stopped, Terminating,
    #    Terminated, Not running
    # @option name         Filter by container name
    # @option unique_name  Filter by unique name
    #
    # @return [Array[Tutum::Container]] list of returned containers
    def self.list(options={}, cnxn=nil)
      options[:state] = tutumize_state(options[:state]) if options[:state]
      resp = connection(cnxn).containers.list(options)
      resp.nil? || resp['objects'].nil? and raise "Unreadable response: #{resp}"
      resp['objects'].map do |raw|
        self.new(raw, cnxn)
      end
    end

    # Get the Container object with the given ID
    def self.get(uuid, cnxn=nil)
      raw = connection(cnxn).containers.get(uuid)
      self.new(raw, cnxn)
    end

    # Get the logs of the specified container.
    def logs(uuid)
      connection.containers.logs(uuid)
    end

    # Starts a stopped container
    def start()
      # return true  if started?
      # return false if not startable?
      connection.containers.start(uuid).tap{ self.forget }
    end

    # Stops a running container
    def stop()
      # return true  if stopped?
      # return false if not stoppable?
      connection.containers.stop(uuid).tap{ self.forget }
    end

    def terminate()
      # return false if not terminable?
      connection.containers.terminate(uuid).tap{ self.forget }
    end

    # ===========================================================================
    #
    # State
    #

    # The state of the container:
    #
    # * :running         The container is deployed and running.
    #                    Possible actions in this state: stop, terminate.
    # * :init            The container object has been created but hasn''t being deployed yet.
    #                    Possible actions in this state: start, terminate.
    # * :stopped         The container is stopped.
    #                    Possible actions in this state: start, terminate.
    # * :starting        The container is being deployed (from Init) or started (from Stopped).
    #                    No actions allowed in this state.
    # * :stopping        The container is being stopped.
    #                    No actions allowed in this state.
    # * :terminating     The container is being deleted.
    #                    No actions allowed in this state.
    # * :terminated      The container has been deleted.
    #                    No actions allowed in this state.
    def state()
      info[:state]
    end

    STARTABLE_STATES  = [           :init, :stopped ].to_set.freeze          unless defined?(STARTABLE_STATES)
    STOPPABLE_STATES  = [ :running,                 ].to_set.freeze          unless defined?(STOPPABLE_STATES)
    TERMINABLE_STATES = [ :running, :init, :stopped ].to_set.freeze          unless defined?(TERMINABLE_STATES)
    #
    TRANSITION_STATES = [ :starting, :stopping, :terminating ].to_set.freeze unless defined?(TRANSITION_STATES)
    ABSENT_STATES     = [ :terminating, :terminated ].to_set.freeze          unless defined?(ABSENT_STATES)
    DOWN_STATES       = [ :terminating, :terminated, :init, :stopped ].to_set.freeze unless defined?(DOWN_STATES)
    #
    def startable?()  STARTABLE_STATES.include?(state) ; end
    def stoppable?()  STOPPABLE_STATES.include?(state) ; end
    def terminable?() TERMINABLE_STATES.include?(state) ; end
    #
    def running?()    state == :running ; end
    def stopped?()    state == :stopped ; end
    #
    def up?()         running?                      ; end
    def down?()       DOWN_STATES.include?(state)   ; end
    def absent?()     ABSENT_STATES.include?(state) ; end
    def exists?()     not absent?                   ; end

    # ===========================================================================
    #
    # Mechanics
    #

    def normalize_response(raw)
      raw = super(raw)
      #
      raw[:bindings]            = Tutum::BindSpec.receive_list(raw[:bindings])            if raw.include?(:bindings)
      raw[:container_ports]     = Tutum::PortSpec.receive_list(raw[:container_ports])     if raw.include?(:container_ports)
      raw
    end

  end
end
