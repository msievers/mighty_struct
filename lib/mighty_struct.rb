require "mighty_struct/version"

class MightyStruct
  def self.new?(object)
    object.is_a?(Enumerable)
  end

  # in order not to pollute the instance's method namespace this is a class method
  def self.to_object(object)
    object.is_a?(self) ? object.instance_variable_get(:@object) : object
  end

  def initialize(object, options = {})
    unless self.class.new?(object)
      raise ArgumentError.new("Cannot create a an instance of #{self.class} for the given object!")
    end

    @cache = options[:caching] == :enabled ? {} : nil

    if (@object = object).respond_to?(:keys)
      object.keys.each do |_key|
        unless respond_to?(_key)
          define_singleton_method(_key) do
            if @cache
               @cache[_key] ||= self.class.new?(value = @object[_key]) ? self.class.new(value) : value
            else
              self.class.new?(value = @object[_key]) ? self.class.new(value) : value
            end
          end
        end
      end
    end
  end

  #
  # last line of defense
  #
  def method_missing(method_name, *arguments, &block)
    if @object.respond_to?(method_name)
      @cache.clear if @cache # clear the properties cache, because the called method may have side-effects
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
