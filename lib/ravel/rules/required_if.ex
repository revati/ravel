defmodule Ravel.Rules.RequiredIf do
  alias Ravel.Rules.RequiredIf
  alias Ravel.Rules.Required

  @moduledoc """
    iex> Ravel.Rules.RequiredIf.validate nil, %Ravel.Rules.RequiredIf{name: :another_field}, :field, [field: nil, another_field: nil]
    false

    iex> Ravel.Rules.RequiredIf.validate "item", %Ravel.Rules.RequiredIf{name: :another_field}, :field, [field: "item", another_field: nil]
    true

    iex> Ravel.Rules.RequiredIf.validate nil, %Ravel.Rules.RequiredIf{name: :another_field}, :field, [field: nil]
    true

    iex> Ravel.Rules.RequiredIf.validate "item", %Ravel.Rules.RequiredIf{name: :another_field}, :field, [field: "item"]
    true

    iex> Ravel.Rules.RequiredIf.validate nil, %Ravel.Rules.RequiredIf{name: :another_field, value: "value"}, :field, [field: nil, another_field: nil]
    true

    iex> Ravel.Rules.RequiredIf.validate "item", %Ravel.Rules.RequiredIf{name: :another_field, value: "value"}, :field, [field: "item", another_field: nil]
    true

    iex> Ravel.Rules.RequiredIf.validate nil, %Ravel.Rules.RequiredIf{name: :another_field, value: "value"}, :field, [field: nil, another_field: "value"]
    false

    iex> Ravel.Rules.RequiredIf.validate "item", %Ravel.Rules.RequiredIf{name: :another_field, value: "value"}, :field, [field: "item", another_field: "value"]
    true
  """

  defstruct name: nil, value: nil

  def validate(value, %RequiredIf{name: field_name, value: nil}, key, data) do
    case Keyword.has_key? data, field_name do
      true -> Required.validate value, %Required{}, key, data
      false -> true
    end
  end

  def validate(value, %RequiredIf{name: field_name, value: field_value}, key, data) do
    case Keyword.get data, field_name do
      ^field_value -> Required.validate value, %Required{}, key, data
      _ -> true
    end
  end
end
