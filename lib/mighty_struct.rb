require "mighty_struct/version"

class MightyStruct
  def self.define_property_accessors!(mighty_struct, object)
    if object.respond_to?(:[]) && object.respond_to?(:keys)
      object.keys.each do |_key|
        mighty_struct.singleton_class.class_eval <<-EORUBY, __FILE__, __LINE__ + 1
          def #{_key}
            value = @object[#{_key.is_a?(Symbol) ? ':' << _key.to_s : '"' << _key << '"'}]
            self.class.new?(value) ? self.class.new(value) : value
          end
        EORUBY
      end
    end
  end

  def self.new?(object)
    object.is_a?(Enumerable)
  end

  def initialize(object)
    unless self.class.new?(object)
      raise ArgumentError.new("Cannot create a an instance of #{self.class} for the given object!")
    end

    self.class.define_property_accessors!(self, @object = object)
  end

  #
  # last line of defense
  #
  def method_missing(method_name, *arguments, &block)
    if @object.respond_to?(method_name)
      result = @object.send(method_name, *arguments, &block)

      # ensure that results of called methods are mighty structs again
      self.class.new?(result) ? self.class.new(result) : result
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    @object.respond_to?(method_name) || super
  end
end
