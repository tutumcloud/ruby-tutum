# -*- coding: utf-8 -*-
class Tutum
  class Volume < Tutum::Base
    # A unique identifier for the volume generated automatically on creation
    attr_reader :uuid

    # A unique API endpoint that represents the volume
    attr_reader :resource_uri

    def forget()
      @node = @vol_group_id = @containers = nil
      super
    end

    # The resource URI of the node where this is located
    def node_id()               ; info[:node]            ; end

    # The resource URI of the volume group this volume belongs to
    def vol_group_id()          ; info[:volump_group]    ; end

    # List of the resource URIs of the containers using this volume
    def container_ids()         ; info[:containers]      ; end


    # ===========================================================================
    #
    # Relations
    #

    def node()
      @node       ||= _get_node(node_id)
    end

    def vol_group()
      @vol_group  ||= _get_vol_group(vol_group_id)
    end

    def containers()
      @containers ||= container_ids.map{|id| _get_container(id) }
    end

    # ===========================================================================
    #
    # Actions
    #

    # @return [Array[Tutum::Volume]] list of returned volumes
    def self.list(options={}, cnxn=nil)
      resp = _list(options, cnxn)
      resp.nil? || resp['objects'].nil? and raise "Unreadable response: #{resp}"
      resp['objects'].map do |raw|
        self.new(raw, cnxn)
      end
    end

    # Get the Volume object with the given ID
    def self.get(uuid, cnxn=nil)
      raw = _get(uuid, cnxn)
      self.new(raw, cnxn)
    end

    # ===========================================================================
    #
    # State
    #

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
    def terminable?() TERMINABLE_STATES.include?(state) ; end
    def created?()    state == :created ; end
    #
    def up?()         created?                      ; end
    def down?()       absent?                       ; end
    def absent?()     ABSENT_STATES.include?(state) ; end
    def exists?()     not absent? ; end

    # ===========================================================================
    #
    # Personal Actions
    #

    def self._list(params={}, cnxn=nil)
      connection(cnxn).volumes.http_get("/volume/", params)
    end

    def self._get(uuid, cnxn=nil)
      connection(cnxn).volumes.http_get("/volume/#{TutumApi.stripped_id(uuid)}/")
    end

  end
end
