# -*- coding: utf-8 -*-
class Tutum
  # A volume group is a representation of a group of Docker volumes belonging to
  # a service and sharing the same container mount point.
  #
  class VolGroup < Tutum::Base
    # A unique identifier for the volume group generated automatically on creation
    attr_reader :uuid

    # A unique API endpoint that represents the volume group
    attr_reader :resource_uri

    def forget()
      @services = @volumes  = nil
      super
    end

    # The name of the volume group
    def name()               ; info[:name]                   ; end

    # The resource URI of the node where this volume is located
    def service_ids()        ; info[:services]            ; end

    # List of the resource URIs of the containers using this volume
    def volume_ids()         ; info[:volumes]      ; end

    # ===========================================================================
    #
    # Relations
    #

    def services()
      @services ||= service_ids.map{|id| _get_service(id) }
    end

    def volumes()
      @volumes ||= volume_ids.map{|id|   _get_volume(id)  }
    end

    # ===========================================================================
    #
    # Actions
    #

    # @return [Array[Tutum::Volume]] list of returned volume groups
    def self.list(options={}, cnxn=nil)
      resp = _list(options, cnxn)
      resp.nil? || resp['objects'].nil? and raise "Unreadable response: #{resp}"
      resp['objects'].map do |raw|
        self.new(raw, cnxn)
      end
    end

    # Get the VolGroup object with the given ID
    def self.get(uuid, cnxn=nil)
      raw = _get(uuid, cnxn)
      self.new(raw, cnxn)
    end

    # ===========================================================================
    #
    # State
    #

    # The state of the vol group:
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
    def created?() state == :created ; end
    #
    def up?()      created?                      ; end
    def down?()    absent?                       ; end
    def absent?()  ABSENT_STATES.include?(state) ; end
    def exists?()  not absent? ; end

    # ===========================================================================
    #
    # Personal Actions
    #

    def self._list(params={}, cnxn=nil)
      connection(cnxn).vol_groups.http_get("/volumegroup/", params)
    end

    def self._get(uuid, cnxn=nil)
      connection(cnxn).vol_groups.http_get("/volumegroup/#{TutumApi.stripped_id(uuid)}/")
    end

  end
end
