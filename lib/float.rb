class << Float

  # thanks http://www.hans-eric.com/code-samples/ruby-floating-point-round-off/
  def round_to_two(f)
    (f * 10**2).round.to_f / 10**2
  end

end
