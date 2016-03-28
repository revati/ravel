defmodule Ravel.Rules.RequiredUnless do
  use Ravel.Rule
  alias Ravel.Rules.Required

  @doc """
    iex> Ravel.Rules.RequiredUnless.validate "", [:anotherKey], :field_name, []
    :required

    iex> Ravel.Rules.RequiredUnless.validate 1, [:anotherKey], :field_name, []
    :ok

    iex> Ravel.Rules.RequiredUnless.validate "", [:anotherKey], :field_name, [anotherKey: "another value"]
    :required

    iex> Ravel.Rules.RequiredUnless.validate 1, [:anotherKey], :field_name, [anotherKey: "another value"]
    :ok

    iex> Ravel.Rules.RequiredUnless.validate 1, [:anotherKey], :field_name, [anotherKey: ""]
    :ok

    iex> Ravel.Rules.RequiredUnless.validate "", [:anotherKey], :field_name, [anotherKey: ""]
    :ok

    iex> Ravel.Rules.RequiredUnless.validate "", [:anotherKey, "another value"], :field_name, []
    :required

    iex> Ravel.Rules.RequiredUnless.validate "", [:anotherKey, "another value"], :field_name, [anotherKey: ""]
    :required

    iex> Ravel.Rules.RequiredUnless.validate "", [:anotherKey, "another value"], :field_name, [anotherKey: "another value"]
    :ok

    iex> Ravel.Rules.RequiredUnless.validate "", [:anotherKey, "another value"], :field_name, [anotherKey: "different value"]
    :required

    iex> Ravel.Rules.RequiredUnless.validate 1, [:anotherKey, "another value"], :field_name, [anotherKey: "another value"]
    :ok
  """
  def validate(value, [aKey,aValue], key, values) do
    case Keyword.get(values, aKey, nil) do
      ^aValue ->
        :ok
      _ ->
        Required.validate(value, [], key, values)
    end
  end

  def validate(value, [aKey], key, values) do
    case Keyword.get(values, aKey, nil) do
      nil ->
        Required.validate(value, [], key, values)
      aValue ->
        case empty? aValue do
          true -> :ok
          false -> Required.validate(value, [], key, values)
        end

    end
  end
end