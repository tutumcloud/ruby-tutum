class Tutum
  #
  # Parent class for lightweight bags-of-values.
  # This lets us receive eg `{"name":"...","inner_port":"..."....}`
  # from the API but access things as my_service.links.first.inner_port
  #
  # Concrete classes will define a
  # class method .fields returning the list of attributes to
  # * receive from a hash at initialize
  # * turn back into a hash on call to #attributes
  #
  class BaseSpec
    # @param [Hash] hash of values for each field
    def initialize(raw)
      raw.to_hash.each do |key, val|
        instance_variable_set("@#{key}", val) if self.class.fields.include?(key.to_sym)
      end
    end

    # @return [Hash] hash of values for each field
    def attributes
      Hash[ self.class.fields.map{|attr| [attr, self.send(attr)] } ]
    end

    # Given a list of raw hashes, return a list of objects with this class' type
    # @return [Array[Tutum::Base]]
    def self.receive_list(raws)
      return [] if raws.nil?
      raws.map{|raw| self.new(raw) }
    end
  end

  class LinkSpec < BaseSpec
    # The link name
    attr_reader :name
    # The resource URI of the origin of the link
    attr_reader :from_service
    # The resource URI of the target of the link
    attr_reader :to_service

    def self.fields()
      [:name, :from_service, :to_service]
    end
  end

  class PortSpec < BaseSpec
    attr_reader :port_name
    # Whether the port has been published in the host public network interface or not. Non-published ports can only be accessed via links.
    # The published port number inside the container
    attr_reader :inner_port
    # The published port number in the node public network interface
    attr_reader :outer_port
    # Name of the service associated to this port
    attr_reader :published
    # The protocol of the port, either tcp or udp
    attr_reader :protocol
    # The protocol to be used in the endpoint for this port (i.e. http)
    attr_reader :uri_protocol
    # The URI of the endpoint for this port
    attr_reader :endpoint_uri

    def self.fields()
      [:port_name, :inner_port, :outer_port, :published, :protocol,
        :endpoint_uri, :uri_protocol]
    end
  end


  class BindSpec < BaseSpec
    # The container folder where the volume is mounted
    attr_reader :container_path
    # The host folder of the volume
    attr_reader :host_path
    # true if the volume has writable permissions
    attr_reader :rewritable
    # The resource URI of the volume group
    attr_reader :volume_group

    def self.fields()
      [:container_path, :host_path, :rewritable, :volume_group, :volume, ]
    end
  end
end
