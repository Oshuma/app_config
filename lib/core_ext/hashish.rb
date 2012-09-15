# Stolen from Rails Active Support and renamed to Hashish.
#
# This class has dubious semantics and we only have it so that
# people can get the same value for key as String and Symbol. See example:
#
# @example
#   hashish = Hashish.new({:key => "value"})
#   hashish[:key] #=> "value"
#   hashish["key"] #=> "value"

class Hashish < Hash
  def initialize(constructor = {})
    if constructor.is_a?(Hash)
      super()
      update(constructor)
    else
      super(constructor)
    end
  end

  def default(key = nil)
    if key.is_a?(Symbol) && include?(key = key.to_s)
      self[key]
    else
      super
    end
  end

  alias_method :regular_writer, :[]= unless method_defined?(:regular_writer)
  alias_method :regular_update, :update unless method_defined?(:regular_update)

  # Assigns a new value to the hash:
  #
  #     hash = Hashish.new
  #     hash[:key] = "value"
  def store(key, value)
    regular_writer(convert_key(key), convert_value(value))
  end
  alias :[]=  :store

  # Updates the instantized hash with values from the second:
  #
  #     hash_1 = Hashish.new
  #     hash_1[:key] = "value"
  #
  #     hash_2 = Hashish.new
  #     hash_2[:key] = "New Value!"
  #
  #     hash_1.update(hash_2) # => {"key"=>"New Value!"}
  def update(other_hash)
    other_hash.each_pair { |key, value| regular_writer(convert_key(key), convert_value(value)) }
    self
  end

  alias_method :merge!, :update

  # Checks the hash for a key matching the argument passed in:
  #
  #     hash = Hashish.new
  #     hash["key"] = "value"
  #     hash.key? :key  # => true
  #     hash.key? "key" # => true
  def key?(key)
    super(convert_key(key))
  end

  alias_method :include?, :key?
  alias_method :has_key?, :key?
  alias_method :member?, :key?

  # Fetches the value for the specified key.
  #
  # @example
  #   hashish = Hashish.new({:key => "value"})
  #   hashish.fetch(:key) #=> "value"
  #   hashish.fetch("key") #=> "value"
  #   hashish[:key] #=> "value"
  #   hashish["key"] #=> "value"
  def fetch(key, *extras)
    super(convert_key(key), *extras)
  end

  # Returns an array of the values at the specified indices:
  #
  #     hash = Hashish.new
  #     hash[:a] = "x"
  #     hash[:b] = "y"
  #     hash.values_at("a", "b") # => ["x", "y"]
  def values_at(*indices)
    indices.collect {|key| self[convert_key(key)]}
  end

  # Returns an exact copy of the hash.
  def dup
    Hashish.new(self)
  end

  # Merges the instantized and the specified hashes together, giving precedence to the values from the second hash
  # Does not overwrite the existing hash.
  def merge(hash)
    self.dup.update(hash)
  end

  # Performs the opposite of merge, with the keys and values from the first hash taking precedence over the second.
  # This overloaded definition prevents returning a regular hash, if reverse_merge is called on a HashWithDifferentAccess.
  def reverse_merge(other_hash)
    super other_hash.with_indifferent_access
  end

  # {include:#reverse_merge} It replaces the actual object.
  #
  # @see #reverse_merge
  #
  def reverse_merge!(other_hash)
    replace(reverse_merge( other_hash ))
  end

  # Removes a specified key from the hash.
  def delete(key)
    super(convert_key(key))
  end

  def stringify_keys!; self end
  def symbolize_keys!; self end
  def to_options!; self end

  # Convert to a Hash with String keys.
  #
  # @example
  #   hashish = Hashish.new({:key => 'value', :four => 20})
  #   hashish.to_hash #=> {"key" => "value", "four" => 20}
  #
  # @return [Hash] hash
  def to_hash
    Hash.new(default).merge!(self)
  end

  # Converts hash to YAML.
  #
  # @example
  #   hashish = Hashish.new({:key => 'value', :four => 20})
  #   hashish.to_yaml #=> "---\nkey: value\nfour: 20\n"
  #
  # @return [::YAML] yaml
  def to_yaml
    require 'yaml'
    to_hash.to_yaml
  end

  # Converts hash to JSON.
  #
  # @example
  #   hashish = Hashish.new({:key => 'value', :four => 20})
  #   hashish.to_json #=> "{\"key\":\"value\",\"four\":20}"
  #
  # @return [JSON] json
  def to_json
    require 'json'
    to_hash.to_json
  end

  alias_method :reset, :clear

  # Writes your configuration in file which is located in your specified path.
  #
  # @param file [String] Path of file, which will be written.
  # @param options [Hash]
  #
  # It will be configured by the _options_ hash. _options_ can have the following
  # keys:
  # * *:format*: Format (YAML, JSON, Hash) of converted data.
  #
  # @raise [ArgumentError] if no format is set.
  #
  # @example Save as YAML
  #   hashish.save!("path/to/file.yml", :format => :yaml)
  # @example Save as JSON
  #   hashish.save!("path/to/file.json", :format => :json)
  # @example Save as Hash
  #   hashish.save!("path/to/file.txt", :format => :hash)
  #
  # @note It could overwrite your file.
  #
  # @see #to_yaml
  # @see #to_json
  # @see #to_hash
  #
  # @return true if file could be written.
  def save!(file, options={})
    raise ArgumentError, "You have to specify :format" unless options[:format]
    # :format => :to_format
    format = "to_#{options[:format].downcase}".to_sym
    content = send(format)
    File.open(file, 'w') { |f| f.puts content }
    true
  end

  protected

  def convert_key(key)
    key.kind_of?(Symbol) ? key.to_s : key
  end

  def convert_value(value)
    case value
    when Hash
      value.with_indifferent_access
    when Array
      value.collect { |e| e.is_a?(Hash) ? e.with_indifferent_access : e }
    else
      value
    end
  end

  private

  # You have access by method.
  #
  # @note You use Hash. Use methods with prefix "_" to have definitely access to values.
  #
  # @example Normal usage
  #   hashish = Hashish.new({:newkey => "value"})
  #   hashish[:newkey] #=> "value"
  #   hashish.newkey #=> "value"
  #   hashish._newkey #=> "value"
  #   # with dynamic setter:
  #   hashish.anotherkey = "anothervalue"
  #   hashish.anotherkey #=> "anothervalue"
  #   hashish._somekey = "somevalues"
  #   hashish.somekey #=> "somevalues"
  #
  # @example Problem with Hash methods like Hash#key
  #   hashish = Hashish.new({:key => "value"})
  #   hashish[:key] #=> "value"
  #   config.key # raises ArgumentError, because Hash#key needs an argument.
  #   # But you can use:
  #   config._key #=> "value"
  def method_missing(method, *args, &blk)
    prefix = '_'
    method = method[prefix.length..-1] if method.to_s.start_with? prefix

    if args.empty?
      key = method
      fetch(method, *args) if has_key? key
    elsif method.to_s.end_with?("=")
      # :newkey= => :newkey
      key = method[0..-2].to_sym
      value = args.first
      store(key, value)
    end
  end

end # Hashish

class Hash
  # Converts Hash to {Hashish}.
  def with_indifferent_access
    hash = Hashish.new(self)
    hash.default = self.default
    hash
  end
end
