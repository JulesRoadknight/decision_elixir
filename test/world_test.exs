defmodule WorldTest do
  use ExUnit.Case
  doctest World

  test "it returns the state including the turn number at the end of a turn" do
    input_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 100},
      %Person{id: 2, genes: "bbbbcccc", survival_chance: 51}
    ]
    output_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 100},
      %Person{id: 2, genes: "bbbbcccc", survival_chance: 51}
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
    assert World.tick(input) == expected_output
  end

  test "it returns the updated survival chances each turn" do
    input_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 100},
      %Person{id: 2, genes: "bbbbcccc", survival_chance: 51}
    ]
    output_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 99},
      %Person{id: 2, genes: "bbbbcccc", survival_chance: 50}
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
        "turn" => 0,
        "population" => output_population
      }
    }
    assert World.apply_survival_tick(input) == expected_output
  end

  test "#apply_survival_tick" do
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
      %Person{id: 2, genes: "bbbbcccc", survival_chance: 48}
    ]
    output_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 52},
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
        "turn" => 0,
        "population" => output_population
      }
    }
    assert World.make_decisions(input) == expected_output
  end

  test "agents that `die` are removed" do
    decisions_path = "test/oneDecision.json"
    input_population = [
      %Person{id: 1, genes: "aaaa", survival_chance: 100},
      %Person{id: 2, genes: "bbbbcccc", survival_chance: 0},
      %Person{id: 3, genes: "dd", survival_chance: 100},
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
        "turn" => 0,
        "population" => output_population
      }
    }
    assert World.survival_check(input) == expected_output
  end

  test "#reproduction_check applies based on reproduction parameters" do
    input_population = [
      %Person{id: 1, genes: "abcd", survival_chance: 100},
      %Person{id: 2, genes: "wxyz", survival_chance: 51}
    ]
    possible_child_outcomes = [
      %Person{id: 31, genes: "abyz", survival_chance: 60},
      %Person{id: 31, genes: "wxcd", survival_chance: 60}
    ]
    input = %{
      "decisions" => "test/blankDecisions.json",
      "agents_total" => 30,
      "reproduction_frequency" => 5,
      "world" => %{
        "turn" => 5,
        "population" => input_population
      }
    }
    assert Enum.at(World.reproduction_check(input)["world"]["population"], 2) in possible_child_outcomes
  end

  test "#reproduction_check produces a child for every existing pair" do
    input_population = [
      %Person{id: 1, genes: "abcd", survival_chance: 100},
      %Person{id: 2, genes: "efgh", survival_chance: 51},
      %Person{id: 5, genes: "ijkl", survival_chance: 100},
      %Person{id: 7, genes: "mnop", survival_chance: 51},
      %Person{id: 19, genes: "qrst", survival_chance: 100},
      %Person{id: 100, genes: "uvwx", survival_chance: 51},
      %Person{id: 10000, genes: "yzzz", survival_chance: 51}
    ]
    input = %{
      "decisions" => "test/blankDecisions.json",
      "agents_total" => 11,
      "reproduction_frequency" => 5,
      "world" => %{
        "turn" => 5,
        "population" => input_population
      }
    }
    assert length(World.reproduction_check(input)["world"]["population"]) == 10
    assert World.reproduction_check(input)["agents_total"] == 14
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
    assert length(World.pair_off_reproduction(input_population, 0)) === 3
  end

  test "#pair_off_loop produces a child for every existing pair" do
    input_population = [
      [%Person{id: 1, genes: "abcd", survival_chance: 100}, %Person{id: 2, genes: "efgh", survival_chance: 51}],
      [%Person{id: 5, genes: "ijkl", survival_chance: 100}, %Person{id: 7, genes: "mnop", survival_chance: 51}],
      [%Person{id: 19, genes: "qrst", survival_chance: 100}, %Person{id: 100, genes: "uvwx", survival_chance: 51}],
    ]
    assert length(World.pair_off_loop(input_population, 0, [])) === 3
  end
end
