defmodule Ravel.Stub.ManyFieldsRules do
  use Ravel.Validatable

  defstruct my_field: nil, my_second_field: nil

  validate :my_field, "required|size:12"
  validate :my_second_field, "required"
end
