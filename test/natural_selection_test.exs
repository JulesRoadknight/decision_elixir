defmodule NaturalSelectionTest do
  use ExUnit.Case
  doctest NaturalSelection

  test "it runs a game for one turn" do
    decisions_path = "test/blankDecisions.json"
    input_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 100},
      %Person{id: 2, genes: "bbbbcccc", survival_chance: 51}
    ]
    output_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 99},
      %Person{id: 2, genes: "bbbbcccc", survival_chance: 50}
    ]
    input = %{
      "decisions" => decisions_path,
      "world" => %{
        "turn" => 0,
        "population" => input_population
      }
    }
    expected_output = %{
      "decisions" => decisions_path,
      "world" => %{
        "turn" => 1,
        "population" => output_population
      }
    }
    assert NaturalSelection.run(input) == expected_output
  end

  test "applies the result of a decision each turn" do
    decisions_path = "test/oneDecision.json"
    input_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 50},
      %Person{id: 2, genes: "bbbbcccc", survival_chance: 49}
    ]
    output_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 51},
      %Person{id: 2, genes: "bbbbcccc", survival_chance: 50}
    ]
    input = %{
      "decisions" => decisions_path,
      "world" => %{
        "turn" => 0,
        "population" => input_population
      }
    }
    expected_output = %{
      "decisions" => decisions_path,
      "world" => %{
        "turn" => 1,
        "population" => output_population
      }
    }
    assert NaturalSelection.run(input) == expected_output
  end

  test "agents that `die` are removed" do
    decisions_path = "test/oneDecision.json"
    input_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 99},
      %Person{id: 2, genes: "bbbbcccc", survival_chance: 0},
      %Person{id: 3, genes: "dd", survival_chance: 99},
      %Person{id: 4, genes: "bbbbcccc", survival_chance: 0}
    ]
    output_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 100},
      %Person{id: 3, genes: "dd", survival_chance: 100}
    ]
    input = %{
      "decisions" => decisions_path,
      "world" => %{
        "turn" => 0,
        "population" => input_population
      }
    }
    expected_output = %{
      "decisions" => decisions_path,
      "world" => %{
        "turn" => 1,
        "population" => output_population
      }
    }
    assert NaturalSelection.run(input) == expected_output
  end
end
