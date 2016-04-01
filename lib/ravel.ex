defmodule Ravel do
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