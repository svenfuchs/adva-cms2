class Array
  def flatten_once
    inject([]) { |result, elem| elem.is_a?(Array) ? result + elem : result << elem }
  end

  def flatten_once!
    replace(flatten_once)
  end
end