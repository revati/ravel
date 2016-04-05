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

  @spec blank?(any) :: boolean
  def blank?(value)
end

defimpl Ravel.Blank, for: List do
  @spec blank?(list) :: boolean
  def blank?([]), do: true
  def blank?(_),  do: false
end

defimpl Ravel.Blank, for: Float do
  @spec blank?(float) :: boolean
  def blank?(0.0), do: true
  def blank?(_), do: false
end

defimpl Ravel.Blank, for: Integer do
  @spec blank?(integer) :: boolean
  def blank?(0), do: true
  def blank?(_), do: false
end

defimpl Ravel.Blank, for: Tuple do
  @spec blank?(tuple) :: boolean
  def blank?({}), do: true
  def blank?(_),  do: false
end

defimpl Ravel.Blank, for: BitString do
  @spec blank?(binary) :: boolean
  def blank?(""), do: true
  def blank?(_),  do: false
end

defimpl Ravel.Blank, for: Atom do
  @spec blank?(atom) :: boolean
  def blank?(nil),   do: true
  def blank?(false), do: true
  def blank?(_),     do: false
end

defimpl Ravel.Blank, for: Map do
  @spec blank?(map) :: boolean
  def blank?(map), do: map_size(map) == 0
end

defimpl Ravel.Blank, for: Function do
  @spec blank?(fun) :: boolean
  def blank?(function), do: :erlang.fun_info(function)[:arity] == 0
end

defimpl Ravel.Blank, for: PID do
  @spec blank?(pid) :: boolean
  def blank?(_pid), do: false
end

defimpl Ravel.Blank, for: Port do
  @spec blank?(port) :: boolean
  def blank?(_port), do: false
end

defimpl Ravel.Blank, for: Reference do
  @spec blank?(reference) :: boolean
  def blank?(_reference), do: false
end

defimpl Ravel.Blank, for: Any do
  def blank?(_), do: false
end
