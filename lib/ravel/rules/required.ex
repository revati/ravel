defmodule Ravel.Rules.Required do
  use Ravel.Rule

  @doc """
    iex> Ravel.Rules.Required.validate "", [], :field_name, []
    :required

    iex> Ravel.Rules.Required.validate "a", [], :field_name, []
    :ok

    iex> Ravel.Rules.Required.validate [], [], :field_name, []
    :required

    iex> Ravel.Rules.Required.validate [1], [], :field_name, []
    :ok

    iex> Ravel.Rules.Required.validate [1, 2], :field_name, [], []
    :ok

    iex> Ravel.Rules.Required.validate {}, [], :field_name, []
    :required

    iex> Ravel.Rules.Required.validate {1}, [], :field_name, []
    :ok

    iex> Ravel.Rules.Required.validate {1, 2}, [], :field_name, []
    :ok
  """
  def validate(value, _options, _key, _values), do: if empty?(value), do: :required, else: :ok
end