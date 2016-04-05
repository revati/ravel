defmodule Ravel.Rules.Accepted do
  alias Ravel.Rules.Accepted

  @moduledoc """
  iex> Ravel.Rules.Accepted.validate nil, %Ravel.Rules.Accepted{}, :field, []
  false

  iex> Ravel.Rules.Accepted.validate 5, %Ravel.Rules.Accepted{}, :field, [field: 5]
  false

  iex> Ravel.Rules.Accepted.validate "value", %Ravel.Rules.Accepted{}, :field, [field: "value"]
  false

  iex> Ravel.Rules.Accepted.validate 1, %Ravel.Rules.Accepted{}, :field, [field: 1]
  true

  iex> Ravel.Rules.Accepted.validate true, %Ravel.Rules.Accepted{}, :field, [field: true]
  true

  iex> Ravel.Rules.Accepted.validate "on", %Ravel.Rules.Accepted{}, :field, [field: "on"]
  true

  iex> Ravel.Rules.Accepted.validate "yes", %Ravel.Rules.Accepted{}, :field, [field: "yes"]
  true
  """

  defstruct []

  def validate(true, %Accepted{}, _key, _data), do: true
  def validate(1, %Accepted{}, _key, _data), do: true
  def validate("yes", %Accepted{}, _key, _data), do: true
  def validate("on", %Accepted{}, _key, _data), do: true
  def validate(_value, %Accepted{}, _key, _data), do: false
end
