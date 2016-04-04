defmodule Ravel.Guard do

  @moduledoc """
    iex> defmodule NoValidation do
    ...>   use Ravel.Guard
    ...>   defstruct name: nil
    ...> end
    ...> NoValidation.rules
    {:fields_set, %{}}

    iex> defmodule NoValidation2 do
    ...>   use Ravel.Guard
    ...>   defstruct name: nil
    ...> end
    ...> NoValidation2.valid? []
    :ok

    iex> defmodule WithValidation do
    ...>   use Ravel.Guard
    ...>   defstruct name: nil
    ...>   guard :name, [%Ravel.Rules.Required{}]
    ...> end
    ...> WithValidation.rules
    {:fields_set, %{name: {:rules, [%Ravel.Rules.Required{}]}}}

    iex> defmodule WithValidation2 do
    ...>   use Ravel.Guard
    ...>   defstruct name: nil
    ...>   guard :name, [%Ravel.Rules.Required{}]
    ...> end
    ...> WithValidation2.valid? []
    [name: [%Ravel.Rules.Required{}]]

    iex> defmodule WithValidation3 do
    ...>   use Ravel.Guard
    ...>   defstruct name: nil
    ...>   guard :name, [%Ravel.Rules.Required{}]
    ...> end
    ...> WithValidation3.valid? [name: "some"]
    :ok

    iex> defmodule WithManyValidation do
    ...>   use Ravel.Guard
    ...>   defstruct name: nil, surname: nil
    ...>   guard :name, [%Ravel.Rules.Required{}]
    ...>   guard :surname, [%Ravel.Rules.Minimum{min: 5}]
    ...> end
    ...> WithManyValidation.rules
    {:fields_set, %{name: {:rules, [%Ravel.Rules.Required{}]}, surname: {:rules, [%Ravel.Rules.Minimum{min: 5}]}}}

    iex> defmodule WithManyValidation2 do
    ...>   use Ravel.Guard
    ...>   defstruct name: nil, surname: nil
    ...>   guard :name, [%Ravel.Rules.Required{}]
    ...>   guard :surname, [%Ravel.Rules.Minimum{min: 5}]
    ...> end
    ...> WithManyValidation2.valid? [surname: "doe"]
    [name: [%Ravel.Rules.Required{}], surname: [%Ravel.Rules.Minimum{min: 5}]]

    iex> defmodule WithManyValidation3 do
    ...>   use Ravel.Guard
    ...>   defstruct name: nil, surname: nil
    ...>   guard :name, [%Ravel.Rules.Required{}]
    ...>   guard :surname, [%Ravel.Rules.Minimum{min: 5}]
    ...> end
    ...> WithManyValidation3.valid? [surname: "doedoe", name: "name"]
    :ok

    iex> defmodule Title do
    ...>   use Ravel.Guard
    ...>   defstruct title: nil
    ...>   guard :title, [%Ravel.Rules.Required{}]
    ...> end
    ...> defmodule WithNestedValidation do
    ...>   use Ravel.Guard
    ...>   defstruct title: nil, description: nil
    ...>   guard :title, Title.rules
    ...>   guard :description, [%Ravel.Rules.Minimum{min: 5}]
    ...> end
    ...> WithNestedValidation.rules
    {:fields_set, %{description: {:rules, [%Ravel.Rules.Minimum{min: 5}]}, title: {:rules, {:fields_set, %{title: {:rules, [%Ravel.Rules.Required{}]}}}}}}

    iex> defmodule Title2 do
    ...>   use Ravel.Guard
    ...>   defstruct title: nil
    ...>   guard :title, [%Ravel.Rules.Required{}]
    ...> end
    ...> defmodule WithNestedValidation2 do
    ...>   use Ravel.Guard
    ...>   defstruct title: nil, description: nil
    ...>   guard :title, Title2.rules
    ...>   guard :description, [%Ravel.Rules.Minimum{min: 5}]
    ...> end
    ...> WithNestedValidation2.valid? []
    [title: [title: [%Ravel.Rules.Required{}]]]
  """
  defmacro __using__(_) do
    quote do
      @rules %{}
      @before_compile unquote(__MODULE__)

      import unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_) do
    quote do
      def rules, do: {:fields_set, @rules}
 
      def valid?(data), do: Ravel.validate data, rules
    end
  end

  defmacro guard(field, rules) do
    quote bind_quoted: [field: field, rules: rules], unquote: true do
      @rules Map.put(@rules, field, {:rules, rules})
    end
  end
end
