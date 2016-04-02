defmodule Ravel.Rules.Maximum do
  alias Ravel.Rules.Maximum

  @moduledoc """
    iex> Ravel.Rules.Maximum.validate nil, %Ravel.Rules.Maximum{max: 5}, :field, []
    true

    iex> Ravel.Rules.Maximum.validate "12345", %Ravel.Rules.Maximum{max: 5}, :field, []
    true

    iex> Ravel.Rules.Maximum.validate "123456", %Ravel.Rules.Maximum{max: 5}, :field, []
    false
  """

  defstruct max: nil

  def validate(value, %Maximum{max: max}, key, data) do
    case Ravel.Blank.blank? value do
      true  -> true
      false ->
        case Ravel.Size.size value do
          x when x <= max -> true
          _ -> false
        end
    end
  end
end
