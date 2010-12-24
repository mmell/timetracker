class Float

  # thanks http://www.hans-eric.com/code-samples/ruby-floating-point-round-off/
  def round_to_two
    (self * 10**2).round.to_f / 10**2
  end

end
