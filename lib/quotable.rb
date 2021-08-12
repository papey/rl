class String
  MAX_LENGTH = 270

  def surround
    "« #{self} »".validate
  end

  def open
    "« #{self}...".validate
  end

  def continue
    "...#{self}...".validate
  end

  def close
    "...#{self} »".validate
  end

  def validate
    raise "Sentence too long, max length is #{MAX_LENGTH} (sentence length is #{length})" if length > MAX_LENGTH

    self
  end
end
