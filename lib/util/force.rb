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
    values.any?
  end

  def false?
    !true?
  end

  private

  def values
    KEYS.map { |o| @options[o] }
  end
end
