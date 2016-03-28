defmodule Ravel.RulesNormalizer do
  @moduledoc """
    iex> Ravel.RulesNormalizer.normalize {:rules_set, "required"},
    ...> ["required/0": Revent.Validation.Rules.Required]
    {:n_rules_set, [[Revent.Validation.Rules.Required]]}

    iex> Ravel.RulesNormalizer.normalize {:n_rules_set, [[Revent.Validation.Rules.Required]]},
    ...> ["required/0": Revent.Validation.Rules.Required]
    {:n_rules_set, [[Revent.Validation.Rules.Required]]}

    iex> Ravel.RulesNormalizer.normalize {:rules_set, "required|min_length:12"},
    ...> ["required/0": Revent.Validation.Rules.Required, "min_length/1": Revent.Validation.Rules.MinLength]
    {:n_rules_set, [[Revent.Validation.Rules.Required], [Revent.Validation.Rules.MinLength, "12"]]}

    iex> Ravel.RulesNormalizer.normalize {:rules_set, ["required"]},
    ...> ["required/0": Revent.Validation.Rules.Required]
    {:n_rules_set, [[Revent.Validation.Rules.Required]]}

    iex> Ravel.RulesNormalizer.normalize {:rules_set, ["required", "min_length:12"]},
    ...> ["required/0": Revent.Validation.Rules.Required, "min_length/1": Revent.Validation.Rules.MinLength]
    {:n_rules_set, [[Revent.Validation.Rules.Required], [Revent.Validation.Rules.MinLength, "12"]]}

    iex> Ravel.RulesNormalizer.normalize {:rules_set, [["required"]]},
    ...> ["required/0": Revent.Validation.Rules.Required]
    {:n_rules_set, [[Revent.Validation.Rules.Required]]}

    iex> Ravel.RulesNormalizer.normalize {:rules_set, [["required"], ["min_length", "12"]]},
    ...> ["required/0": Revent.Validation.Rules.Required, "min_length/1": Revent.Validation.Rules.MinLength]
    {:n_rules_set, [[Revent.Validation.Rules.Required], [Revent.Validation.Rules.MinLength, "12"]]}

    iex> Ravel.RulesNormalizer.normalize {:rules_set, [[:required]]},
    ...> ["required/0": Revent.Validation.Rules.Required]
    {:n_rules_set, [[Revent.Validation.Rules.Required]]}

    iex> Ravel.RulesNormalizer.normalize {:rules_set, [[:required], [:min_length, "12"]]},
    ...> ["required/0": Revent.Validation.Rules.Required, "min_length/1": Revent.Validation.Rules.MinLength]
    {:n_rules_set, [[Revent.Validation.Rules.Required], [Revent.Validation.Rules.MinLength, "12"]]}

    iex> Ravel.RulesNormalizer.normalize {:rules_set, [[Revent.Validation.Rules.Required]]},
    ...> ["required/0": Revent.Validation.Rules.Required]
    {:n_rules_set, [[Revent.Validation.Rules.Required]]}

    iex> Ravel.RulesNormalizer.normalize {:rules_set, [[Revent.Validation.Rules.Required], [Revent.Validation.Rules.MinLength, "12"]]},
    ...> ["required/0": Revent.Validation.Rules.Required, "min_length/1": Revent.Validation.Rules.MinLength]
    {:n_rules_set, [[Revent.Validation.Rules.Required], [Revent.Validation.Rules.MinLength, "12"]]}

    iex> Ravel.RulesNormalizer.normalize {:fields_set, [my_field: {:rules_set, "required"}]},
    ...> ["required/0": Revent.Validation.Rules.Required]
    {:n_fields_set, [my_field: {:n_rules_set, [[Revent.Validation.Rules.Required]]}]}

    iex> Ravel.RulesNormalizer.normalize {:fields_set, [my_field: {:rules_set, "required"}, another_field: {:rules_set, "required|min_length:12"}]},
    ...> ["required/0": Revent.Validation.Rules.Required, "min_length/1": Revent.Validation.Rules.MinLength]
    {:n_fields_set, [my_field: {:n_rules_set, [[Revent.Validation.Rules.Required]]}, another_field: {:n_rules_set, [[Revent.Validation.Rules.Required], [Revent.Validation.Rules.MinLength, "12"]]}]}
  """
  def normalize({:n_rules_set, rules}, _registered_rules), do: {:n_rules_set, rules}
  def normalize({:n_fields_set, rules}, _registered_rules), do: {:n_fields_set, rules}

  def normalize({:rules_set, rules}, registered_rules) do
    {:n_rules_set, normalize_rules_set(rules, registered_rules)}
  end

  def normalize({:fields_set, fields}, registered_rules) do
    {:n_fields_set, normalize_fields_set(fields, registered_rules)}
  end

  # By default asume that single field will be normalized
  def normalize(rules, registered_rules), do: normalize {:rules_set, rules}, registered_rules

  defp normalize_fields_set(fields, registered_rules) when is_map(fields) do
    normalize_fields_set Map.to_list(fields), registered_rules
  end

  defp normalize_fields_set(fields, registered_rules) when is_list(fields) do
    Enum.map(fields, fn({key, rules_set}) -> {key, normalize(rules_set, registered_rules)} end)
  end

  defp normalize_rules_set(rules, registered_rules) when is_binary(rules) do
    normalize_rules_set String.split(rules, "|", trim: true), registered_rules
  end

  defp normalize_rules_set(rules, registered_rules) when is_map(rules) do
    normalize_rules_set Map.to_list(rules), registered_rules
  end

  defp normalize_rules_set(rules, registered_rules) when is_list(rules) do
    Enum.map(rules, fn(rule) -> normalize_rule rule, registered_rules end)
  end

  defp normalize_rule(rule, registered_rules) when is_binary(rule) do
    normalize_rule String.split(rule, ":", trim: true), registered_rules
  end

  defp normalize_rule([rule|options], registered_rules) when is_binary(rule) do
    name = normalized_name rule, options
    handler = convert_to_handler name, registered_rules

    [handler|options]
  end

  defp normalize_rule([rule|options], registered_rules) when is_atom(rule) do
    # Check if is module atom
    case String.starts_with?(Atom.to_string(rule), "Elixir") do
      true -> [rule|options]
      false -> normalize_rule [Atom.to_string(rule)|options], registered_rules
    end
  end

  defp convert_to_handler(name, registered_rules) do
    case registered_rules[name] do
        nil -> raise "missing validation handler for #{name}"
        handler -> handler
    end
  end

  defp normalized_name(rule, options), do: String.to_atom "#{rule}/#{length options}"
end
