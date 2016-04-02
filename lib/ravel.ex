defmodule Ravel do
  @moduledoc """
    iex> Ravel.validate [field_name: nil], {:fields_set, [field_name: {:rules, [%Ravel.Rules.Required{}]}]}
    [field_name: [%Ravel.Rules.Required{}]]

    iex> Ravel.validate [field_name: "value"], {:fields_set, [field_name: {:rules, [%Ravel.Rules.Required{}]}]}
    :ok

    iex> Ravel.validate [field_name: "value"], {:fields_set, [field_name: {:rules, [%Ravel.Rules.Required{}, %Ravel.Rules.Minimum{min: 5}]}]}
    :ok

    iex> Ravel.validate [field_name: "value"], {:fields_set, [field_name: {:rules, [%Ravel.Rules.Required{}, %Ravel.Rules.Minimum{min: 10}]}]}
    [field_name: [%Ravel.Rules.Minimum{min: 10}]]

    iex> Ravel.validate [field_name: nil, another_field: nil], {:fields_set, [field_name: {:rules, [%Ravel.Rules.Required{}]}, another_field: {:rules, [%Ravel.Rules.Required{}]}]}
    [field_name: [%Ravel.Rules.Required{}], another_field: [%Ravel.Rules.Required{}]]

    iex> Ravel.validate [field_name: [sub_field: nil]], {:fields_set, [field_name: {:rules, {:fields_set, [sub_field: {:rules, [%Ravel.Rules.Required{}]}]}}]}
    [field_name: [sub_field: [%Ravel.Rules.Required{}]]]

    iex> Ravel.validate [field_name: [sub_field: "value"]], {:fields_set, [field_name: {:rules, {:fields_set, [sub_field: {:rules, [%Ravel.Rules.Required{}]}]}}]}
    :ok
  """

  def validate(data, {:fields_set, fields}) do
    apply_layer(data, fields, fn(key, rules) -> validate(data, rules, key) end)
  end

  defp validate(data, {:rules, {:fields_set, fields}}, field_name) do
    data = data[field_name]

    validate(data, {:fields_set, fields})
  end

  defp validate(data, {:rules, rules}, field_name) do
    apply_layer(data, rules, fn(rule) -> apply_rule(rule, data, field_name) end)
  end

  def validate(data, fields) do
    validate(data, {:fields_set, fields})
  end

  defp apply_rule(rule, data, key) do
    module = rule.__struct__
    value = data[key]

    case module.validate(value, rule, key, data) do
      true  -> :ok
      false -> rule
    end
  end

  defp apply_layer(data, items_set, apply_callback) when is_function(apply_callback, 1) do
    response = items_set
    |> Enum.map(fn(item) -> apply_callback.(item) end)
    |> Enum.filter(&filter_out_successfull/1)

    case response do
      [] -> :ok
      _ -> response
    end
  end

  defp apply_layer(data, items_set, apply_callback) when is_function(apply_callback, 2) do
    response = items_set
    |> Enum.map(fn({key, item}) -> {key, apply_callback.(key, item)} end)
    |> Enum.filter(&filter_out_successfull/1)

    case response do
      [] -> :ok
      _ -> response
    end
  end

  defp filter_out_successfull(:ok), do: false
  defp filter_out_successfull({_, :ok}), do: false
  defp filter_out_successfull(_), do: true
end