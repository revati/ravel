defmodule Ravel.Validatable do
  alias Ravel

  defmacro __using__(_opts) do
    quote do
      @rules %{}
      @before_compile unquote(__MODULE__)

      import unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_) do
    quote do
      def rules, do: Ravel.normalize {:fields_set, @rules}

      def valid?(data), do: Ravel.validate data, rules
    end
  end

  defmacro validate(field, rules) do
    quote bind_quoted: [field: field, rules: rules], unquote: true do
      @rules Map.put(@rules, field, rules)
    end
  end

  defmacro validate(rules) do
    # ? Validate whole module
  end
end
