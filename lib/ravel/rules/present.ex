defmodule Ravel.Rules.Present do
  alias Ravel.Rules.Present

  @moduledoc """
    iex> Ravel.Rules.Present.validate nil, %Ravel.Rules.Present{}, :field, []
    false

    iex> Ravel.Rules.Present.validate 5, %Ravel.Rules.Present{}, :field, [field: 5]
    true

    iex> Ravel.Rules.Present.validate "", %Ravel.Rules.Present{}, :field, [field: ""]
    true
  """

  defstruct []

  def validate(value, %Present{}, key, data), do: Keyword.has_key? data, key
end
