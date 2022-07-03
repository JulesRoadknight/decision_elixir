defmodule WorldTest do
  use ExUnit.Case
  doctest World

  test "it returns the state including the turn number at the end of a turn" do
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
    assert World.take_turn(input) == expected_output
  end

  test "it returns the updated survival chances each turn" do
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
    assert World.take_turn(input) == expected_output
  end

  test "#apply_survival_tick" do
    decisions_path = "test/blankDecisions.json"
    input_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 100},
      %Person{id: 2, genes: "bbbbcccc", survival_chance: 0}
    ]
    output_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 99},
      %Person{id: 2, genes: "bbbbcccc", survival_chance: -1}
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
        "turn" => 0,
        "population" => output_population
      }
    }
    assert World.apply_survival_tick(input) == expected_output
  end

  test "#make_decisions modifies survival_chance based on result of decision" do
    decisions_path = "test/oneDecision.json"
    input_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 50},
      %Person{id: 2, genes: "bbbbcccc", survival_chance: 0}
    ]
    output_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 52},
      %Person{id: 2, genes: "bbbbcccc", survival_chance: 2}
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
        "turn" => 0,
        "population" => output_population
      }
    }
    assert World.make_decisions(input) == expected_output
  end
end
