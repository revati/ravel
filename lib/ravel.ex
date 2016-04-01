defmodule Ravel do

  @moduledoc """
    iex> Ravel.validate [field: 5], [field: %Ravel.Rules.Required{name: "what"}]
    :ok
  """
  def normalize rules do
    Ravel.RulesNormalizer.normalize rules
  end

  def validate data, rules do
    errors = rules
    |> Enum.map(fn({key, rule}) -> apply_rule(rule, data, key) end)
    |> Enum.filter(&filter_out_successfull/1)

    case errors do
      [] -> :ok
      _ -> errors
    end
  end

  defp apply_rule(rule, data, key) do
    module = rule.__struct__
    value = data[key]

    case module.validate(value, rule, key, data) do
      true  -> :ok
      false -> {key, rule}
    end
  end

  defp filter_out_successfull(:ok), do: false
  defp filter_out_successfull(_), do: true
end

defprotocol Ravel.Rules.Required do
  defstruct name: nil

  def validate(value, rule, key, data)
end

defimpl Ravel.Rules.Required, for: Integer do
  def validate(value, %Ravel.Rules.Required{name: name}, key, data) do
    true
  end
end
