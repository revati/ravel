defmodule Ravel.Rules.Size do
  use Ravel.Rule

  @doc """
    iex> Ravel.Rules.Size.validate "", [5], :field_name, []
    :ok

    iex> Ravel.Rules.Size.validate "aabb", [5], :field_name, []
    :size

    iex> Ravel.Rules.Size.validate "aabbc", [5], :field_name, []
    :ok

    iex> Ravel.Rules.Size.validate "aabbcc", [5], :field_name, []
    :size

    iex> Ravel.Rules.Size.validate 4, [5], :field_name, []
    :size

    iex> Ravel.Rules.Size.validate 5, [5], :field_name, []
    :ok

    iex> Ravel.Rules.Size.validate 6, [5], :field_name, []
    :size

    iex> Ravel.Rules.Size.validate [1,2,3], [5], :field_name, []
    :size

    iex> Ravel.Rules.Size.validate [1,2,3,4,5], [5], :field_name, []
    :ok

    iex> Ravel.Rules.Size.validate [1,2,3,4,5,6], [5], :field_name, []
    :size

    iex> Ravel.Rules.Size.validate %{key: "value"}, [5], :field_name, []
    :size

    iex> Ravel.Rules.Size.validate %{key: "value"}, [1], :field_name, []
    :ok

    iex> Ravel.Rules.Size.validate %{key: "value", another_key: "value"}, [1], :field_name, []
    :size
  """
  def validate(value, [size], _key, _values) when is_binary(value) do
    case empty?(value) do
      true -> :ok
      false -> if String.length(value) == size, do: :ok, else: :size
    end
  end

  def validate(value, [size], _key, _values) when is_number(value) do
    case empty?(value) do
      true -> :ok
      false -> if value == size, do: :ok, else: :size
    end
  end

  def validate(value, [size], _key, _values) when is_map(value) do
    case empty?(value) do
      true -> :ok
      false -> if map_size(value) == size, do: :ok, else: :size
    end
  end

  def validate(value, [size], _key, _values) when is_list(value) do
    case empty?(value) do
      true -> :ok
      false -> if length(value) == size, do: :ok, else: :size
    end
  end
end