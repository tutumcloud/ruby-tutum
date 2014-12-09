# -*- coding: utf-8 -*-
class Tutum
  class Volume < Tutum::Base
    # A unique identifier for the volume generated automatically on creation
    attr_reader :uuid

    # A unique API endpoint that represents the volume
    attr_reader :resource_uri

    # @param raw [Hash] The attributes of this volume
    def initialize(raw, cnxn=nil)
      @info         = normalize_response(raw)
      @uuid         = @info[:uuid]
      @resource_uri = @info[:resource_uri]
      @connection   = cnxn if cnxn
    end

    # @return [Array[Tutum::Volume]] list of returned volumes
    def self.list(options={}, cnxn=nil)
      raws = connection(cnxn).volumes.list(options)
      raws.map do |raw|
        self.new(raw, cnxn)
      end
    end

    # Get the Volume object with the given ID
    def self.get(uuid, cnxn=nil)
      raw = connection(cnxn).volumes.get(uuid)
      self.new(raw, cnxn)
    end

    # The resource URI of the node where this volume is located
    def node_id()               ; info[:node]            ; end

    # List of the resource URIs of the containers using this volume
    def container_ids()         ; info[:containers]      ; end

    # The resource URI of the volume group this volume belongs to
    def vol_group_id()          ; info[:volump_group]    ; end

    # The state of the volume:
    #
    # * :created    The volume object has been created in the node and it is available
    # * :terminated The volume has been deleted in the node.
    def state()
      info[:state]
    end

    TERMINABLE_STATES = [ :created ].to_set.freeze          unless defined?(TERMINABLE_STATES)
    ABSENT_STATES     = [ :terminated ].to_set.freeze       unless defined?(ABSENT_STATES)
    #
    def terminable?()   TERMINABLE_STATES.include?(state) ; end
    #
    def created?() state == :created ; end
    def absent?()  ABSENT_STATES.include?(state) ; end
    def exists?()  not absent? ; end

  end
end
