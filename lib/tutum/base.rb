class Tutum
  #
  # Base class for Tutum objects
  #
  class Base
    def initialize(cnxn=nil)
      @connection = cnxn if cnxn
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
      raw
    end

    def normalize_state(raw_state)
      raw_state.to_s.
        downcase.
        gsub(/[^\w]+/, '_').
        gsub(/partly.*running/, 'partly').
        to_sym
    end

    def symbolize_hsh(hsh)
      hsh.keys.each do |key|
        hsh[(key.to_sym rescue key) || key] = hsh.delete(key)
      end
      hsh
    end
  end
end
