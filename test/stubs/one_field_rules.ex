defmodule Ravel.Stub.OneFieldRules do
  use Ravel.Validatable

  defstruct my_field: nil

  validate :my_field, "required|size:12"
end
