defprotocol Ravel.Blank do
  def blank?(value)
end

defimpl Ravel.Blank, for: List do
  def blank?([]), do: true
  def blank?(_),  do: false
end

defimpl Ravel.Blank, for: Float do
  def blank?(0.0), do: true
  def blank?(_), do: false
end

defimpl Ravel.Blank, for: Integer do
  def blank?(0), do: true
  def blank?(_), do: false
end

defimpl Ravel.Blank, for: Tuple do
  def blank?({}), do: true
  def blank?(_),  do: false
end

defimpl Ravel.Blank, for: BitString do
  def blank?(""), do: true
  def blank?(_),  do: false
end

defimpl Ravel.Blank, for: Atom do
  def blank?(nil),   do: true
  def blank?(false), do: true
  def blank?(_),     do: false
end

defimpl Ravel.Blank, for: Map do
  def blank?(map), do: map_size(map) == 0
end

defimpl Ravel.Blank, for: Any do
  def blank?(_), do: false
end
