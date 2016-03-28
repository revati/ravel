defmodule Ravel.Stub.NestedFieldRules do
  use Ravel.Validatable
  alias Ravel.Stub.OneFieldRules

  defstruct my_field: nil, my_second_field: nil

  validate :my_field, "required|size:12"
  validate :nested_field, OneFieldRules.rules
end
