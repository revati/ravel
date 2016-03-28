defmodule Ravel.Rules.RequiredIf do
  use Ravel.Rule
  alias Ravel.Rules.Required

  @doc """
    iex> Ravel.Rules.RequiredIf.validate "", [:anotherKey], :field_name, []
    :ok

    iex> Ravel.Rules.RequiredIf.validate 1, [:anotherKey], :field_name, []
    :ok

    iex> Ravel.Rules.RequiredIf.validate "", [:anotherKey], :field_name, [anotherKey: "another value"]
    :required

    iex> Ravel.Rules.RequiredIf.validate 1, [:anotherKey], :field_name, [anotherKey: "another value"]
    :ok

    iex> Ravel.Rules.RequiredIf.validate 1, [:anotherKey], :field_name, [anotherKey: ""]
    :ok

    iex> Ravel.Rules.RequiredIf.validate "", [:anotherKey, "another value"], :field_name, []
    :ok

    iex> Ravel.Rules.RequiredIf.validate "", [:anotherKey, "another value"], :field_name, [anotherKey: ""]
    :ok

    iex> Ravel.Rules.RequiredIf.validate "", [:anotherKey, "another value"], :field_name, [anotherKey: "another value"]
    :required

    iex> Ravel.Rules.RequiredIf.validate 1, [:anotherKey, "another value"], :field_name, [anotherKey: "another value"]
    :ok
  """
  def validate(value, [aKey,aValue], key, values) do
    case Keyword.get(values, aKey, nil) do
      ^aValue ->
        Required.validate(value, [], key, values)
      what ->
        :ok
    end
  end

  def validate(value, [aKey], key, values) do
    case Keyword.get(values, aKey, nil) do
      nil -> :ok
      aValue ->
        case empty? aKey do
          true -> :ok
          false -> Required.validate(value, [], key, values)
        end
    end
  end
end