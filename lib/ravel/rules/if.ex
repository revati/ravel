defmodule Ravel.Rules.If do
  alias Ravel.Rules.If

  @moduledoc """
    iex> Ravel.Rules.If.validate nil, %Ravel.Rules.If{name: :another_field, rule: %Ravel.Rules.Required{}}, :field, [field: nil]
    true

    iex> Ravel.Rules.If.validate "item", %Ravel.Rules.If{name: :another_field, rule: %Ravel.Rules.Required{}}, :field, [field: "item"]
    true

    iex> Ravel.Rules.If.validate nil, %Ravel.Rules.If{name: :another_field, rule: %Ravel.Rules.Required{}}, :field, [field: nil, another_field: nil]
    false

    iex> Ravel.Rules.If.validate "item", %Ravel.Rules.If{name: :another_field, rule: %Ravel.Rules.Required{}}, :field, [field: "item", another_field: nil]
    true

    iex> Ravel.Rules.If.validate nil, %Ravel.Rules.If{name: :another_field, value: "item", rule: %Ravel.Rules.Required{}}, :field, [field: nil]
    true

    iex> Ravel.Rules.If.validate nil, %Ravel.Rules.If{name: :another_field, value: "item", rule: %Ravel.Rules.Required{}}, :field, [field: nil, another_field: nil]
    true

    iex> Ravel.Rules.If.validate nil, %Ravel.Rules.If{name: :another_field, value: "item", rule: %Ravel.Rules.Required{}}, :field, [field: nil, another_field: "item"]
    false

    iex> Ravel.Rules.If.validate "value", %Ravel.Rules.If{name: :another_field, value: "item", rule: %Ravel.Rules.Required{}}, :field, [field: "value", another_field: "item"]
    true
  """

  defstruct name: nil, value: nil, rule: nil

  def validate(value, %If{name: field_name, value: nil, rule: rule}, key, data) do

    case Keyword.has_key? data, field_name do
      true  -> rule.__struct__.validate value, rule, key, data
      false -> true
    end
  end

  def validate(value, %If{name: field_name, value: field_value, rule: rule}, key, data) do
    case Keyword.get data, field_name do
      ^field_value -> rule.__struct__.validate value, rule, key, data
      _ -> true
    end
  end
end
