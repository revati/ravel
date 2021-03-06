defprotocol Ravel.Blank do

  @moduledoc """
    iex> Ravel.Blank.blank? []
    true

    iex> Ravel.Blank.blank? [1, 2, 3, 4, 5, 6]
    false

    iex> Ravel.Blank.blank? 0.0
    true

    iex> Ravel.Blank.blank? 14.9
    false

    iex> Ravel.Blank.blank? 0
    true

    iex> Ravel.Blank.blank? 14
    false

    iex> Ravel.Blank.blank? {}
    true

    iex> Ravel.Blank.blank? {1,2,3}
    false

    iex> Ravel.Blank.blank? ""
    true

    iex> Ravel.Blank.blank? "12345678"
    false

    iex> Ravel.Blank.blank? nil
    true

    iex> Ravel.Blank.blank? false
    true

    iex> Ravel.Blank.blank? :any_atom
    false

    iex> Ravel.Blank.blank? %{}
    true

    iex> Ravel.Blank.blank? %{field: "value", another_field: "value"}
    false
  """

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
