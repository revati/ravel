defmodule Ravel.Rule do
  alias Ravel.Blank

  defmacro __using__(_opts) do
    quote do
      @before_compile unquote(__MODULE__)

      import unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_) do
    quote do
      defp empty?(value), do: Blank.blank?(value)
    end
  end
end
