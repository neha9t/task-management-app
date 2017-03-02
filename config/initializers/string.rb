class String

  def remove_special_chars
    gsub(/[^0-9A-Za-z\s]/, '')
  end

  def singularize_spaces
    gsub(/\s+/, ' ')
  end
end
