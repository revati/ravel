defmodule Ravel.Rules.IfField do
  alias Ravel.Rules.IfField

  @moduledoc """
    iex> Ravel.Rules.IfField.validate nil, %Ravel.Rules.IfField{name: :another_field, rule: %Ravel.Rules.Required{}}, :field, [field: nil]
    true

    iex> Ravel.Rules.IfField.validate "item", %Ravel.Rules.IfField{name: :another_field, rule: %Ravel.Rules.Required{}}, :field, [field: "item"]
    true

    iex> Ravel.Rules.IfField.validate nil, %Ravel.Rules.IfField{name: :another_field, rule: %Ravel.Rules.Required{}}, :field, [field: nil, another_field: nil]
    false

    iex> Ravel.Rules.IfField.validate "item", %Ravel.Rules.IfField{name: :another_field, rule: %Ravel.Rules.Required{}}, :field, [field: "item", another_field: nil]
    true

    iex> Ravel.Rules.IfField.validate nil, %Ravel.Rules.IfField{name: :another_field, value: "item", rule: %Ravel.Rules.Required{}}, :field, [field: nil]
    true

    iex> Ravel.Rules.IfField.validate nil, %Ravel.Rules.IfField{name: :another_field, value: "item", rule: %Ravel.Rules.Required{}}, :field, [field: nil, another_field: nil]
    true

    iex> Ravel.Rules.IfField.validate nil, %Ravel.Rules.IfField{name: :another_field, value: "item", rule: %Ravel.Rules.Required{}}, :field, [field: nil, another_field: "item"]
    false

    iex> Ravel.Rules.IfField.validate "value", %Ravel.Rules.IfField{name: :another_field, value: "item", rule: %Ravel.Rules.Required{}}, :field, [field: "value", another_field: "item"]
    true
  """

  defstruct name: nil, value: nil, rule: nil

  def validate(value, %IfField{name: field_name, value: nil, rule: rule}, key, data) do

    case Keyword.has_key? data, field_name do
      true  -> rule.__struct__.validate value, rule, key, data
      false -> true
    end
  end

  def validate(value, %IfField{name: field_name, value: field_value, rule: rule}, key, data) do
    case Keyword.get data, field_name do
      ^field_value -> rule.__struct__.validate value, rule, key, data
      _ -> true
    end
  end
end
