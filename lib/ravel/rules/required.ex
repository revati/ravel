defmodule Ravel.Rules.Required do
  alias Ravel.Rules.Required

  @moduledoc """
    iex> Ravel.Rules.Required.validate nil, %Ravel.Rules.Required{}, :field, []
    false

    iex> Ravel.Rules.Required.validate 0, %Ravel.Rules.Required{}, :field, []
    false

    iex> Ravel.Rules.Required.validate 5, %Ravel.Rules.Required{}, :field, []
    true

    iex> Ravel.Rules.Required.validate "", %Ravel.Rules.Required{}, :field, []
    false

    iex> Ravel.Rules.Required.validate "item", %Ravel.Rules.Required{}, :field, []
    true

    iex> Ravel.Rules.Required.validate [], %Ravel.Rules.Required{}, :field, []
    false

    iex> Ravel.Rules.Required.validate ["item"], %Ravel.Rules.Required{}, :field, []
    true

    iex> Ravel.Rules.Required.validate %{}, %Ravel.Rules.Required{}, :field, []
    false

    iex> Ravel.Rules.Required.validate %{field: "item"}, %Ravel.Rules.Required{}, :field, []
    true
  """

  defstruct name: nil

  def validate(value, %Required{name: name}, key, data), do:
    !Ravel.Blank.blank?(value)
end
