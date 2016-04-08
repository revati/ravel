defmodule Ravel do
  @moduledoc ~S"""
  Ravel is validation library for elixir. Mainly created for learning purposes.

  ## Usage

  Maps and named lists can be used as containers for data that must be validated.

      iex> data  = [field_name: "value"]
      iex> rules = {:fields_set, [field_name: {:rules, [%Ravel.Rules.Required{}]}]}
      iex> Ravel.validate data, rules
      :ok

  If error occurs validation rule it self is returned. See examples

      iex> data  = [field_name: nil]
      iex> rules = {:fields_set, [field_name: {:rules, [%Ravel.Rules.Required{}]}]}
      iex> Ravel.validate data, rules
      [field_name: [%Ravel.Rules.Required{}]]

      iex> data  = [field_name: "value"]
      iex> rules = {:fields_set, [field_name: {:rules, [%Ravel.Rules.Minimum{min: 6}]}]}
      iex> Ravel.validate data, rules
      [field_name: [%Ravel.Rules.Minimum{min: 6}]]

  See Ravel.Rules namespace for all predefined rules.

  ### Using with structs

  You can define defmodule with struct like so

      defmodule SomeStruct do
        use Ravel.Guard

        defstruct field: nil, another_field: []

        guard :name, [%Ravel.Rules.Required{}]
        guard :another_field, [%Ravel.Rules.Maximum{max: 10}]
      end

  And than you can validate data against struct rules like so

      # iex> data = [name: nil]
      # iex> SomeStruct.valid? data
      # :ok
  """

  @type data :: list | map
  @type rules :: {:fields_set, list | map}
  @type field_rules :: {:rules, list | rules}
  @type response :: :ok | list

  @doc """
  Is used to validate passed data with passed rules.
  Applys rules to data and checks if all rules are passed

      iex> data  = [field_name: nil]
      iex> rules = {:fields_set, [field_name: {:rules, [%Ravel.Rules.Required{}]}]}
      iex> Ravel.validate data, rules
      [field_name: [%Ravel.Rules.Required{}]]

      iex> data  = [field_name: "value"]
      iex> rules = {:fields_set, [field_name: {:rules, [%Ravel.Rules.Required{}]}]}
      iex> Ravel.validate data, rules
      :ok

      iex> data  = [field_name: "value"]
      iex> rules = {:fields_set, [field_name: {:rules, [%Ravel.Rules.Required{}, %Ravel.Rules.Minimum{min: 5}]}]}
      iex> Ravel.validate data, rules
      :ok

      iex> data  = [field_name: "value"]
      iex> rules = {:fields_set, [field_name: {:rules, [%Ravel.Rules.Required{}, %Ravel.Rules.Minimum{min: 10}]}]}
      iex> Ravel.validate data, rules
      [field_name: [%Ravel.Rules.Minimum{min: 10}]]

      iex> data  = [field_name: nil, another_field: nil]
      iex> rules = {:fields_set, [field_name: {:rules, [%Ravel.Rules.Required{}]}, another_field: {:rules, [%Ravel.Rules.Required{}]}]}
      iex> Ravel.validate data, rules
      [field_name: [%Ravel.Rules.Required{}], another_field: [%Ravel.Rules.Required{}]]

      iex> data  = [field_name: [sub_field: nil]]
      iex> rules = {:fields_set, [field_name: {:rules, {:fields_set, [sub_field: {:rules, [%Ravel.Rules.Required{}]}]}}]}
      iex> Ravel.validate data, rules
      [field_name: [sub_field: [%Ravel.Rules.Required{}]]]

      iex> data  = [field_name: [sub_field: "value"]]
      iex> rules = {:fields_set, [field_name: {:rules, {:fields_set, [sub_field: {:rules, [%Ravel.Rules.Required{}]}]}}]}
      iex> Ravel.validate data, rules
      :ok
  """
  @spec validate(data, rules | field_rules) :: response
  def validate(data, {:fields_set, fields}) do
    apply_layer(fields, fn(key, rules) -> validate(data, rules, key) end)
  end

  defp validate(data, {:rules, {:fields_set, fields}}, field_name) do
    data = data[field_name]

    validate(data, {:fields_set, fields})
  end

  defp validate(data, {:rules, rules}, field_name) do
    apply_layer(rules, fn(rule) -> apply_rule(rule, data, field_name) end)
  end

  defp apply_rule(rule, data, key) do
    module = rule.__struct__
    value = data[key]

    case module.validate(value, rule, key, data) do
      true  -> :ok
      false -> rule
    end
  end

  defp apply_layer(items_set, apply_callback) when is_function(apply_callback, 1) do
    response = items_set
    |> Enum.map(fn(item) -> apply_callback.(item) end)
    |> Enum.filter(&filter_out_successfull/1)

    case response do
      [] -> :ok
      _ -> response
    end
  end

  defp apply_layer(items_set, apply_callback) when is_function(apply_callback, 2) do
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
