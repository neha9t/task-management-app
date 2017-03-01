class String

  def matching(string)
    remove_special_chars.singularize_spaces == string.remove_special_chars.singularize_spaces ? self : nil
  end

  def remove_special_chars
    downcase.gsub(/[^0-9A-Za-z*\s]/, '')
  end

  def replace_space_with_dash
    gsub(/\s/, '-')
  end

  def singularize_spaces
    gsub(/\s+/, ' ')
  end

  def sql_sanity
    gsub(/[^0-9a-z &]/i, ' ').squish
  end
end
