defprotocol Ravel.Size do

  @moduledoc """
    iex> Ravel.Size.size []
    0

    iex> Ravel.Size.size [1, 2, 3, 4, 5, 6]
    6

    iex> Ravel.Size.size 0.0
    0.0

    iex> Ravel.Size.size 14.9
    14.9

    iex> Ravel.Size.size 0
    0

    iex> Ravel.Size.size 14
    14

    iex> Ravel.Size.size {}
    0

    iex> Ravel.Size.size {1,2,3}
    3

    iex> Ravel.Size.size ""
    0

    iex> Ravel.Size.size "12345678"
    8

    iex> Ravel.Size.size %{}
    0

    iex> Ravel.Size.size %{field: "value", another_field: "value"}
    2
  """

  def size(value)
end

defimpl Ravel.Size, for: List do
  def size(x), do: Enum.count x
end

defimpl Ravel.Size, for: Float do
  def size(x), do: x
end

defimpl Ravel.Size, for: Integer do
  def size(x), do: x
end

defimpl Ravel.Size, for: Tuple do
  def size(x), do: tuple_size x
end

defimpl Ravel.Size, for: BitString do
  def size(x), do: String.length x
end

defimpl Ravel.Size, for: Map do
  def size(map), do: map_size(map)
end
