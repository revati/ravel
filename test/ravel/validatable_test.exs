defmodule Ravel.ValidatableTest do
  use ExUnit.Case, async: true
  doctest Ravel.Validatable

  Code.load_file("test/stubs/empty_module.ex")
  Code.load_file("test/stubs/one_field_rules.ex")
  Code.load_file("test/stubs/many_fields_rules.ex")
  Code.load_file("test/stubs/nested_field_rules.ex")

  alias Ravel.Stub.OneFieldRules;
  alias Ravel.Stub.EmptyModule;
  alias Ravel.Stub.NestedFieldRules;
  alias Ravel.Stub.ManyFieldsRules;

  test "empty rules" do
    assert Ravel.Stub.EmptyModule.rules == {:n_fields_set, []}
  end

  test "one field rules" do
    rules = {:n_fields_set, [
      my_field: {:n_rules_set, [
        [Ravel.Rules.Required],
        [Ravel.Rules.Size, "12"]
      ]}
    ]}

    assert OneFieldRules.rules == rules
  end

  test "many fields rules" do
    rules = {:n_fields_set, [
      my_field: {:n_rules_set, [
        [Ravel.Rules.Required],
        [Ravel.Rules.Size, "12"]
      ]},
      my_second_field: {:n_rules_set, [
        [Ravel.Rules.Required]
      ]}
    ]}

    assert ManyFieldsRules.rules == rules
  end

  test "nested fields rules" do
    rules = {:n_fields_set, [
      my_field: {:n_rules_set, [
        [Ravel.Rules.Required],
        [Ravel.Rules.Size, "12"]
      ]},
      nested_field: {:n_fields_set, [
        my_field: {:n_rules_set, [
          [Ravel.Rules.Required],
          [Ravel.Rules.Size, "12"]
        ]}
      ]}
    ]}

    assert NestedFieldRules.rules == rules
  end

  test "validating with empty rules set" do
    assert EmptyModule.valid?(%{}) == :ok
    assert EmptyModule.valid?(%{some_key: "value"}) == :ok
  end

  test "validating one field rules set" do
    assert OneFieldRules.valid?(%{}) == [my_field: [:required]]
    assert OneFieldRules.valid?(%{my_field: "what"}) == [my_field: [:size]]
    assert OneFieldRules.valid?(%{my_field: "what what wh"}) == :ok
    assert OneFieldRules.valid?(%{my_field: "what what what"}) == [my_field: [:size]]
  end

  test "validating many field rules set" do
    assert ManyFieldsRules.valid?(%{}) == [my_field: [:required], my_second_field: [:required]]
    assert ManyFieldsRules.valid?(%{my_field: "what"}) == [my_field: [:size], my_second_field: [:required]]
    assert ManyFieldsRules.valid?(%{my_field: "what what wh"}) == [my_second_field: [:required]]
    assert ManyFieldsRules.valid?(%{my_field: "what what wh", my_second_field: "another"}) == :ok
  end

  test "validating many field rules set with nested rules" do
    assert NestedFieldRules.valid?(%{}) == [my_field: [:required], nested_field: [my_field: [:required]]]
    assert NestedFieldRules.valid?(%{nested_field: %{my_field: "what"}}) == [my_field: [:required], nested_field: [my_field: [:size]]]
    assert NestedFieldRules.valid?(%{nested_field: %{my_field: "what what wh"}}) == [my_field: [:required]]
    assert NestedFieldRules.valid?(%{my_field: "what what wh", nested_field: %{my_field: "what what wh"}}) == :ok
  end
end
