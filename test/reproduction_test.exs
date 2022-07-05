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

  test "#pair_off_reproduction produces a child for every existing pair" do
    input_population = [
      %Person{id: 1, genes: "abcd", survival_chance: 100},
      %Person{id: 2, genes: "efgh", survival_chance: 51},
      %Person{id: 5, genes: "ijkl", survival_chance: 100},
      %Person{id: 7, genes: "mnop", survival_chance: 51},
      %Person{id: 19, genes: "qrst", survival_chance: 100},
      %Person{id: 100, genes: "uvwx", survival_chance: 51},
      %Person{id: 10000, genes: "yzzz", survival_chance: 51}
    ]
    assert length(Reproduction.pair_off_reproduction(input_population, 0)) === 3
  end

  test "#pair_off_loop produces a child for every existing pair" do
    input_population = [
      [%Person{id: 1, genes: "abcd", survival_chance: 100}, %Person{id: 2, genes: "efgh", survival_chance: 51}],
      [%Person{id: 5, genes: "ijkl", survival_chance: 100}, %Person{id: 7, genes: "mnop", survival_chance: 51}],
      [%Person{id: 19, genes: "qrst", survival_chance: 100}, %Person{id: 100, genes: "uvwx", survival_chance: 51}],
    ]
    assert length(Reproduction.pair_off_loop(input_population, 0, [])) === 3
  end
end
