defmodule Ravel do
  alias Ravel.RulesNormalizer

  unless Application.get_env(:ravel, Ravel) do
    raise "Ravel is not configured"
  end

  @moduledoc """
    Validation library

    iex> Ravel.validate [], []
    :ok

    iex> Ravel.validate [], [my_field: "required"]
    [my_field: [:required]]

    iex> Ravel.validate [], [my_field: "required", my_another_field: [["required"]]]
    [my_field: [:required], my_another_field: [:required]]

    iex> Ravel.validate [my_field: "ss"], [my_field: "required"]
    :ok

    iex> Ravel.normalize []
    {:n_fields_set, []}

    iex> Ravel.normalize [my_field: "required"]
    {:n_fields_set, [my_field: {:n_rules_set, [[Ravel.Rules.Required]]}]}

    iex> Ravel.normalize [my_field: "required|size:12"]
    {:n_fields_set, [my_field: {:n_rules_set, [[Ravel.Rules.Required], [Ravel.Rules.Size, "12"]]}]}

    iex> Ravel.normalize [my_field: "required", another_field: "required|size:12"]
    {:n_fields_set, [my_field: {:n_rules_set, [[Ravel.Rules.Required]]}, another_field: {:n_rules_set, [[Ravel.Rules.Required], [Ravel.Rules.Size, "12"]]}]}

    iex> Ravel.normalize {:n_fields_set, [my_field: {:n_rules_set, [[Ravel.Rules.Required], [Ravel.Rules.MinLength, "12"]]}]}
    {:n_fields_set, [my_field: {:n_rules_set, [[Ravel.Rules.Required], [Ravel.Rules.MinLength, "12"]]}]}
  """
  def validate(data, {:n_fields_set, rules}) do
    errors = rules
    |> Enum.map(fn({key, field_rules}) -> {key, data, field_rules} end)
    |> Enum.map(&validate_field/1)
    |> Enum.filter(&filter_out_successfull/1)

    case errors do
      [] -> :ok
      _ -> errors
    end
  end

  def validate(_data, []), do: :ok
  def validate(data, rules), do: validate data, normalize rules

  def normalize(rules) when is_list(rules), do: normalize {:fields_set, rules}
  def normalize(rules) when is_map(rules), do: normalize {:fields_set, rules}
  def normalize(rules), do: RulesNormalizer.normalize rules, config :rules

  defp validate_field({key, data, {:n_rules_set, field_rules}}) do
    validate_field {key, data, field_rules}
  end

  defp validate_field({key, data, {:n_fields_set, field_rules}}) do
    case validate(data[key], {:n_fields_set, field_rules}) do
      :ok -> :ok
      errors -> {key, errors}
    end
  end

  defp validate_field({key, data, field_rules}) do
    errors = field_rules
    |> Enum.map(fn([rule|options]) -> {key, rule, options, data} end)
    |> Enum.map(&apply_rule/1)
    |> Enum.filter(&filter_out_successfull/1)
    |> Enum.map(&convert_to_message/1)

    case errors do
      [] -> :ok
      _ -> {key, errors}
    end
  end

  defp apply_rule({key, rule, options, data}) do
    {apply(rule, :validate, [data[key], options, key, data]), key, options}
  end

  defp filter_out_successfull(:ok), do: false
  defp filter_out_successfull({:ok, _, _}), do: false
  defp filter_out_successfull(error), do: true

  defp config, do: Application.get_env(:ravel, Ravel)
  defp config(key), do: Keyword.get(config, key)
  defp config(key, default), do: Keyword.get(config, key, default)

  defp convert_to_message({error, _key, _options}) do
    # Internationalizing error messages?
    error
  end
end
