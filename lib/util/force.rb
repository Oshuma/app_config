class Force
  KEYS = [:force, :reload]

  def initialize(options)
    @options = options
  end

  def set?
    !values.all? { |o| o.nil? }
  end

  def nil?
    !set?
  end

  def true?
    set? && values.any?
  end

  def false?
    set? && !true?
  end

  def to_s
    return "true"  if true?
    return "false" if false?
    return "unset" if nil?
  end

  private

  def values
    KEYS.map { |o| @options[o] }
  end
end
