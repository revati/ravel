defmodule Ravel.Rules.Between do
  alias Ravel.Rules.Between
  alias Ravel.Size

  @moduledoc """
    iex> Ravel.Rules.Between.validate nil, %Ravel.Rules.Between{min: 5, max: 10}, :field, []
    true

    iex> Ravel.Rules.Between.validate 2, %Ravel.Rules.Between{min: 5, max: 10}, :field, []
    false

    iex> Ravel.Rules.Between.validate 5, %Ravel.Rules.Between{min: 5, max: 10}, :field, []
    true

    iex> Ravel.Rules.Between.validate 15, %Ravel.Rules.Between{min: 5, max: 10}, :field, []
    false
  """

  defstruct min: nil, max: nil

  def validate(value, %Between{min: min, max: max}, _key, _data) do
    case Ravel.Blank.blank? value do
      true  -> true
      false ->
        size = Size.size value

        case {min <= size, size <= max} do
          {true, true} -> true
          _ -> false
        end
    end

  end
end
