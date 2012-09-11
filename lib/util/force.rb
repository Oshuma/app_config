class Force
  KEYS = [:force, :reload]

  def initialize(options)
    @options = options
  end

  def set?
    !values.all? { |o| o.nil? }
  end
  alias nil? set?

  def true?
    values.any?
  end

  private

  def values
    KEYS.map { |o| @options[o] }
  end
end
