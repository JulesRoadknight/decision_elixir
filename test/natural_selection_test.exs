defmodule NaturalSelectionTest do
  use ExUnit.Case
  doctest NaturalSelection

  test "it runs a game for one turn" do
    input_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 100},
      %Person{id: 2, genes: "bbbbcccc", survival_chance: 0}
    ]
    output_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 99},
      %Person{id: 2, genes: "bbbbcccc", survival_chance: -1}
    ]
    input = %{
      "decisions" => "test/blankDecisions.json",
      "world" => %{
        "turn" => 0,
        "population" => input_population
      }
    }
    expected_output = %{
      "decisions" => "test/blankDecisions.json",
      "world" => %{
        "turn" => 1,
        "population" => output_population
      }
    }
    assert NaturalSelection.run(input) == expected_output
  end
end
