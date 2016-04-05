defmodule Ravel.Rules.Minimum do
  alias Ravel.Rules.Minimum

  @moduledoc """
    iex> Ravel.Rules.Minimum.validate nil, %Ravel.Rules.Minimum{min: 5}, :field, []
    true

    iex> Ravel.Rules.Minimum.validate "12345", %Ravel.Rules.Minimum{min: 5}, :field, []
    true

    iex> Ravel.Rules.Minimum.validate "1234", %Ravel.Rules.Minimum{min: 5}, :field, []
    false
  """

  defstruct min: nil

  def validate(value, %Minimum{min: min}, _key, _data) do
    case Ravel.Blank.blank? value do
      true  -> true
      false ->
        case Ravel.Size.size value do
          x when min <= x -> true
          _ -> false
        end
    end
  end
end
