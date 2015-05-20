require "mighty_struct/version"

class MightyStruct
  def self.define_property_accessors!(mighty_struct, object)
    if object.is_a?(Hash)
      object.keys.each do |_key|
        class_eval <<-EORUBY, __FILE__, __LINE__ + 1
          def #{_key}
            value = @object[#{_key.is_a?(Symbol) ? ':' << _key.to_s : '"' << _key << '"'}]
            self.class.new?(value) ? self.class.new(value) : value
          end
        EORUBY
      end
    end
  end

  def self.new?(object)
    object.is_a?(Array) || object.is_a?(Hash)
  end

  def initialize(object)
    unless self.class.new?(object)
      raise ArgumentError.new("Cannot create a an instance of #{self.class} for the given object!")
    end

    self.class.define_property_accessors!(self, @object = object)
  end

  def [](key)
    # ensure indifferent access
    if @object.is_a?(Hash)
      @object[key] || @object[key.to_s] || @object[key.to_sym]
    else
      @object[key]
    end
  end

  #
  # last line of defense
  #
  def method_missing(method_name, *arguments, &block)
    if @object.respond_to?(method_name)
      @object.send(method_name, *arguments, &block)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    @object.respond_to?(method_name) || super
  end
end
