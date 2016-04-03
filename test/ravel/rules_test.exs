defmodule Ravel.RulesTest do
  use ExUnit.Case, async: true
  doctest Ravel.Rules.Between
  doctest Ravel.Rules.IfField
  doctest Ravel.Rules.Maximum
  doctest Ravel.Rules.Minimum
  doctest Ravel.Rules.Required
  doctest Ravel.Rules.RequiredIf
end
