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
      "reproduction_frequency" => 5,
      "world" => %{
        "turn" => 0,
        "population" => input_population
      }
    }
    expected_output = %{
      "decisions" => decisions_path,
      "reproduction_frequency" => 5,
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
      "reproduction_frequency" => 5,
      "world" => %{
        "turn" => 0,
        "population" => input_population
      }
    }
    expected_output = %{
      "decisions" => decisions_path,
      "reproduction_frequency" => 5,
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
      "reproduction_frequency" => 5,
      "world" => %{
        "turn" => 0,
        "population" => input_population
      }
    }
    expected_output = %{
      "decisions" => decisions_path,
      "reproduction_frequency" => 5,
      "world" => %{
        "turn" => 1,
        "population" => output_population
      }
    }
    assert NaturalSelection.run(input) == expected_output
  end

  test "#reproduction_check does nothing on 'off' turns" do
    input_population = [
      %Person{id: 1, genes: "abcd", survival_chance: 100},
      %Person{id: 2, genes: "wxyz", survival_chance: 51}
    ]
    output_population = [
      %Person{id: 1, genes: "abcd", survival_chance: 99},
      %Person{id: 2, genes: "wxyz", survival_chance: 50}
    ]
    input = %{
      "decisions" => "test/blankDecisions.json",
      "agents_total" => 11,
      "reproduction_frequency" => 5,
      "world" => %{
        "turn" => 0,
        "population" => input_population
      }
    }
    expected_output = %{
      "decisions" => "test/blankDecisions.json",
      "agents_total" => 11,
      "reproduction_frequency" => 5,
      "world" => %{
        "turn" => 1,
        "population" => output_population
      }
    }
    assert NaturalSelection.run(input) == expected_output
  end

  test "surviving agents automatically reproduce every x turns" do
    input_population = [
      %Person{id: 1, genes: "abcd", survival_chance: 100},
      %Person{id: 2, genes: "wxyz", survival_chance: 51}
    ]
    possible_child_outcomes = [
      %Person{id: 12, genes: "abyz", survival_chance: 60},
      %Person{id: 12, genes: "wxcd", survival_chance: 60}
    ]
    input = %{
      "decisions" => "test/blankDecisions.json",
      "agents_total" => 11,
      "reproduction_frequency" => 5,
      "world" => %{
        "turn" => 15,
        "population" => input_population
      }
    }
    assert Enum.at(NaturalSelection.run(input)["world"]["population"], 2) in possible_child_outcomes
  end

  test "increments agents_total after reproduction" do
    input_population = [
      %Person{id: 1, genes: "abcd", survival_chance: 100},
      %Person{id: 2, genes: "wxyz", survival_chance: 51}
    ]
    possible_child_outcomes = [
      %Person{id: 12, genes: "abyz", survival_chance: 60},
      %Person{id: 12, genes: "wxcd", survival_chance: 60}
    ]
    input = %{
      "decisions" => "test/blankDecisions.json",
      "agents_total" => 5,
      "reproduction_frequency" => 5,
      "world" => %{
        "turn" => 5,
        "population" => input_population
      }
    }
    assert length(NaturalSelection.run(input)["world"]["population"]) == 3
    assert NaturalSelection.run(input)["agents_total"] === 6
  end
end
