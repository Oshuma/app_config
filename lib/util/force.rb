# You get information about your force items in your options hash.
class Force

  # This array includes symbols which will be used for checking.
  KEYS = [:force, :reload]

  # @example
  #   Force.new({:a => b, :force => true, :c => d})
  def initialize(options)
    @options = options
  end

  # Checks if options hash includes any force key
  #
  # @example
  #   Force.new({:force => true}).set? #=> true
  #   Force.new({:force => false}).set? #=> true
  #   Force.new({}).set? #=> false
  #
  # @return true if any key is set
  def set?
    values.any? { |o| !o.nil? }
  end

  # Checks if options hash doesn't include any force key
  #
  # @see #set?
  # @example
  #   Force.new({:force => true}).nil? #=> false
  #   Force.new({:force => false}).nil? #=> false
  #   Force.new({}).nil? #=> true
  #
  # @return true if no key is set
  def nil?
    !set?
  end

  # Checks if options hash includes one of the force keys and if its value is true
  #
  # @example
  #   Force.new({:force => true}).true? #=> true
  #   Force.new({:force => false}).true? #=> false
  #   Force.new({}).true? #=> false
  #
  # @return true if any force key is set and its value is true
  def true?
    set? && values.any?
  end

  # Checks if options hash includes one of the force keys and if its value is false
  #
  # @example
  #   Force.new({:force => true}).false? #=> false
  #   Force.new({:force => false}).false? #=> true
  #   Force.new({}).false? #=> false
  #
  # @return true if any force key is set and its value is false
  def false?
    set? && !true?
  end

  # String representation
  #
  # @example Stringify with :force
  #   Force.new({:force => true}).to_s #=> "true"
  #   Force.new({:force => false}).to_s #=> "false"
  #   Force.new({}).to_s #=> "unset"
  #
  # @example Stringify with :reload
  #   Force.new({:reload => true}).to_s #=> "true"
  #   Force.new({:reload => false}).to_s #=> "false"
  #   Force.new({}).to_s #=> "unset"
  #
  # @return [String] value
  def to_s
    return "true"  if true?
    return "false" if false?
    return "unset" if nil?
  end

  private

  # Select only the force keys
  def values
    KEYS.map { |o| @options[o] }
  end
end
