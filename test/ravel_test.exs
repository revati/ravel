defmodule RavelTest do
  use ExUnit.Case, async: true
  doctest Ravel.Validator
  doctest Ravel.Blank
  doctest Ravel.Size
  doctest Ravel.Guard
end
