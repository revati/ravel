defmodule RavelTest do
  use ExUnit.Case, async: true
  doctest Ravel
  doctest Ravel.Validator
  doctest Ravel.Blank
  doctest Ravel.Size
end
