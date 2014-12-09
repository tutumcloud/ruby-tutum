class Tutum
  #
  # Base class for Tutum objects
  #
  class Base
    # @param raw [Hash] The attributes of this object
    def initialize(raw, cnxn=nil)
      @info         = normalize_response(raw)
      @uuid         = @info[:uuid]
      @resource_uri = @info[:resource_uri]
      @connection   = cnxn if cnxn
    end

    # The set of attributes that come for free from create and list.
    def info
      @info     || _refresh!
    end
    protected :info

    # Attributes that do not come for free from create and list. This forces an
    # extra call to the API if it hasn't been made
    def ext_info
      @ext_info || _refresh!
    end
    protected :ext_info

    # Ruby time object for the given field
    # @return [Time]
    def info_time(field)
      Time.parse(info[field]) rescue nil
    end

    # Renew all information from the remote API
    # @return the raw hash of attributes
    def _refresh!
      raw = connection.services.get(uuid)
      @info = @ext_info = normalize_response(raw)
    end
    protected :_refresh!

    # Renew all information from the remote API
    # @return self
    def refresh!
      forget
      _refresh!
      return self
    end

    # Discards all cached info; it will be lazily renewed if needed.
    #
    def forget
      remove_instance_variable('@info')     if instance_variable_defined?('@info')
      remove_instance_variable('@ext_info') if instance_variable_defined?('@ext_info')
      nil
    end

    # falls back from provided, to instance-level, to global
    def self.connection(cnxn=nil)
      cnxn ||  Tutum.connection
    end

    # falls back from provided, to instance-level, to global
    def connection(cnxn=nil)
      cnxn ||  @connection || Tutum.connection
    end

    # normalizes a response hash
    def normalize_response(raw)
      raw = symbolize_hsh(raw.dup)
      raw[:state] = normalize_state(raw[:state])
      #
      #
      # TODO REMOVE

      raw[:container_envvars] = {}
      raw[:link_variables]    = {}
      #
      #
      raw
    end

    def normalize_state(raw_state)
      raw_state.to_s.
        downcase.
        gsub(/[^\w]+/, '_').
        gsub(/partly.*running/, 'partly').
        gsub(/empty.*cluster/,  'empty').
        to_sym
    end

    def self.tutumize_state(st)
      st.to_s.
        split.map(&:capitalize).join(' ').
        gsub(/^partly$/, 'Partly Running').
        gsub(/^empty$/,  'Empty_cluster')
    end

    def symbolize_hsh(hsh)
      hsh.keys.each do |key|
        hsh[(key.to_sym rescue key) || key] = hsh.delete(key)
      end
      hsh
    end


    #
    # These exist so that subclasses can delegate to their subclassed friends.
    # Like most of us in high school, probably.
    #

    def _get_service(uuid)      Tutum::Service.get(uuid)   ; end
    def _get_container(uuid)    Tutum::Container.get(uuid) ; end
    def _get_volume(uuid)       Tutum::Volume.get(uuid)    ; end
    def _get_vol_group(uuid)    Tutum::VolGroup.get(uuid)  ; end
    def _get_node(uuid)         Tutum::Node.get(uuid)      ; end
    def _get_node_cluster(uuid) Tutum::Node.get(uuid)      ; end

  end
end
