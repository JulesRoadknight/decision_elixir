defmodule ReproductionTest do
  use ExUnit.Case
  doctest Reproduction

  test "#standard_reproduction produces a third agent with half of each parents' genes" do
    parent_one = %Person{id: 1, genes: "aaaa", survival_chance: 100}
    parent_two = %Person{id: 2, genes: "bcde", survival_chance: 100}
    child = %Person{id: 3, genes: "aade", survival_chance: 60}
    assert Reproduction.standard_reproduction([parent_one, parent_two], 2) == child
  end

  test "#standard_reproduction works with a different length of genes" do
    parent_one = %Person{id: 9, genes: "ddeddf", survival_chance: 100}
    parent_two = %Person{id: 10, genes: "bbcyyz", survival_chance: 100}
    child = %Person{id: 14, genes: "ddeyyz", survival_chance: 60}
    assert Reproduction.standard_reproduction([parent_one, parent_two], 13) == child
  end
end
