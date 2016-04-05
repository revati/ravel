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

  @spec size(any) :: non_neg_integer
  def size(value)
end

defimpl Ravel.Size, for: List do
  @spec size(list) :: non_neg_integer
  def size(x), do: Enum.count x
end

defimpl Ravel.Size, for: Float do
  @spec size(float) :: non_neg_integer
  def size(x), do: x
end

defimpl Ravel.Size, for: Integer do
  @spec size(integer) :: non_neg_integer
  def size(x), do: x
end

defimpl Ravel.Size, for: Tuple do
  @spec size(tuple) :: non_neg_integer
  def size(x), do: tuple_size x
end

defimpl Ravel.Size, for: BitString do
  @spec size(binary) :: non_neg_integer
  def size(x), do: String.length x
end

defimpl Ravel.Size, for: Atom do
  @spec size(atom) :: non_neg_integer
  def size(nil),   do: 0
  def size(false), do: 0
  def size(x),     do: String.length Atom.to_string x
end

defimpl Ravel.Size, for: Map do
  @spec size(map) :: non_neg_integer
  def size(map), do: map_size(map)
end

defimpl Ravel.Size, for: Function do
  @spec size(fun) :: non_neg_integer
  def size(function), do: :erlang.fun_info(function)[:arity]
end

defimpl Ravel.Size, for: PID do
  @spec size(pid) :: non_neg_integer
  def size(pid), do: 1 # What?
end

defimpl Ravel.Size, for: Port do
  @spec size(port) :: non_neg_integer
  def size(port), do: 1 # What?
end

defimpl Ravel.Size, for: Reference do
  @spec size(reference) :: non_neg_integer
  def size(reference), do: 1 # What?
end
