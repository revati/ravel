defmodule Ravel.RulesTest do
  use ExUnit.Case, async: true
  doctest Ravel.Rules.Accepted
  doctest Ravel.Rules.Between
  doctest Ravel.Rules.IfField
  doctest Ravel.Rules.Maximum
  doctest Ravel.Rules.Minimum
  doctest Ravel.Rules.Present
  doctest Ravel.Rules.Required
end
