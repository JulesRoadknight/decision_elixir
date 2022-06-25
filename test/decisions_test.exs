defmodule DecisionsTest do
  use ExUnit.Case
  doctest Decisions

  test "it makes a decision when there is no decision" do
    person = %Person{id: 1, genes: "aaaa"}
    decisions_path = "test/blankDecisions.json"
    assert Decisions.make_decision(person, decisions_path) == "Do nothing"
  end

  test "it makes a decision when there is one decision" do
    person = %Person{id: 1, genes: "aaaa"}
    decisions_path = "test/oneDecision.json"
    assert Decisions.make_decision(person, decisions_path) == "Win"
  end

  test "it makes a different decision when there is one decision" do
    person = %Person{id: 1, genes: "aaaa"}
    decisions_path = "test/oneOtherDecision.json"
    assert Decisions.make_decision(person, decisions_path) == "Lose"
  end

  test "it makes a decision when there are two decisions" do
    person = %Person{id: 1, genes: "aaaa"}
    decisions_path = "test/twoDecisions.json"
    assert Decisions.make_decision(person, decisions_path) in ["Win", "Lose"]
  end

  test "sums total choice of decisions" do
    decisions_path = "test/twoDecisions.json"
    { _status, decisions_list} = Decisions.get_decisions(decisions_path)
    assert Decisions.sum_choices(decisions_list) == 2
  end

  test "finds matching result of decision" do
    decisions_path = "test/twoDecisions.json"
    { _status, decisions_list} = Decisions.get_decisions(decisions_path)
    assert Decisions.decision_result(1, decisions_list) == "Win"
  end

  test "finds other matching result of decision" do
    decisions_path = "test/twoDecisions.json"
    { _status, decisions_list} = Decisions.get_decisions(decisions_path)
    assert Decisions.decision_result(2, decisions_list) == "Lose"
  end

  test "fixes a result when first character is `B`" do
    person = %Person{id: 1, genes: "Baaa"}
    decisions_path = "test/fixedWhenFirstB.json"
    assert Decisions.make_decision(person, decisions_path) == "Only for B"
  end

  test "choices with modifiers removes choices without modifiers" do
    decisions_path = "test/fixedWhenFirstB.json"
    { _status, decisions } = Decisions.get_decisions(decisions_path)

    expected_result = [%{
      "name" => "Only for B",
      "chance" => 0,
      "modifiers" => [%{
        "position" => 0,
        "match" => "B",
        "weight" => 0
      },
      %{
        "position" => 0,
        "match" => "C",
        "weight" => 1
      }]
    }]

    assert Decisions.choices_with_modifiers(decisions) == expected_result
  end

  test "modifiers with certainty only returns certainties" do
    input = [%{
      "name" => "Only for B",
      "chance" => 0,
      "modifiers" => [%{
        "position" => 0,
        "match" => "B",
        "weight" => 0
      },
      %{
        "position" => 0,
        "match" => "C",
        "weight" => 1
      }
    ]
    }]

    expected_result = [%{
      "name" => "Only for B",
      "chance" => 0,
      "modifiers" => [%{
        "position" => 0,
        "match" => "B",
        "weight" => 0
      }]
    }]

    assert Decisions.modifiers_with_certainty(input) == expected_result
  end

  test "loads to modifiers with certainty" do
    decisions_path = "test/fixedWhenFirstB.json"
    expected_result = [%{
      "name" => "Only for B",
      "chance" => 0,
      "modifiers" => [%{
        "position" => 0,
        "match" => "B",
        "weight" => 0
      }]
    }]
    { _status, decisions } = Decisions.get_decisions(decisions_path)
    assert Decisions.choices_with_modifiers(decisions) |> Decisions.modifiers_with_certainty() == expected_result
  end

  test "decisions are loaded correctly" do
    decisions_path = "test/fixedWhenFirstB.json"
    { _status, decisions } = Decisions.get_decisions(decisions_path)
    expected_decisions = [
      %{
          "name" => "Not B",
          "chance" => 1
      },
      %{
          "name" => "Only for B",
          "chance" => 0,
          "modifiers" => [%{
            "position" => 0,
            "match" => "B",
            "weight" => 0
          },
          %{
              "position" => 0,
              "match" => "C",
              "weight" => 1
            }]
      }
    ]
    assert decisions == expected_decisions
  end

  test "does not fix a result when first character is not `B`" do
    person = %Person{id: 1, genes: "aaaa"}
    decisions_path = "test/fixedWhenFirstB.json"
    assert Decisions.make_decision(person, decisions_path) == "Not B"
  end

  test "check for certainties is nil when there are no certainties" do
    person = %Person{id: 1, genes: "aaaa"}
    decisions_path = "test/twoDecisions.json"
    { _status, decisions_list} = Decisions.get_decisions(decisions_path)
    assert Decisions.check_for_certainties(person, decisions_list) == nil
  end

  test "check for certainties is nil when no matches" do
    person = %Person{id: 1, genes: "aaaa"}
    decisions_path = "test/fixedWhenFirstB.json"
    { _status, decisions } = Decisions.get_decisions(decisions_path)
    assert Decisions.check_for_certainties(person, decisions) == nil
  end

  test "matching_certainties returns certainties that match" do
    person = %Person{id: 1, genes: "Baaa"}
    certainties = [%{
      "name"=> "For B",
      "chance"=> 0,
      "modifiers"=> [%{
        "position"=> 0,
        "match"=> "B",
        "weight"=> 0
      }]
    }]
    assert Decisions.matching_certainties(certainties, person) == certainties
  end

  test "matching_certainties removes certainties that do not match" do
    person = %Person{id: 1, genes: "aaaa"}
    certainties = [%{
      "name"=> "For B or C",
      "chance"=> 0,
      "modifiers"=> [%{
        "position"=> 0,
        "match"=> "B",
        "weight"=> 0
      },
      %{
        "position"=> 0,
        "match"=> "C",
        "weight"=> 0
      }]
    }]
    assert Decisions.matching_certainties(certainties, person) == [%{"chance" => 0, "modifiers" => [], "name" => "For B or C"}]
  end

  test "matches a choice when it contains the character in position" do
    person = %Person{id: 1, genes: "Baaa"}
    choice = [%{
      "name"=> "For B or C",
      "chance"=> 0,
      "modifiers"=> [%{
        "position"=> 0,
        "match"=> "B",
        "weight"=> 0
      },
      %{
        "position"=> 0,
        "match"=> "C",
        "weight"=> 1
        }]
    }]

    certainties = [%{
      "name"=> "For B or C",
      "chance"=> 0,
      "modifiers"=> [%{
        "position"=> 0,
        "match"=> "B",
        "weight"=> 0
      }]
    }]
    assert Decisions.matching_certainties(choice, person) == certainties
  end

  test "matches the second choice when it contains the character in position" do
    person = %Person{id: 1, genes: "Caaa"}

    choice = [%{
      "name"=> "For B or C",
      "chance"=> 0,
      "modifiers"=> [%{
        "position"=> 0,
        "match"=> "B",
        "weight"=> 0
      },
      %{
        "position"=> 0,
        "match"=> "C",
        "weight"=> 0
      }]
    }]

    expected_result = [%{
      "name"=> "For B or C",
      "chance"=> 0,
      "modifiers"=> [%{
        "position"=> 0,
        "match"=> "C",
        "weight"=> 0
      }]
    }]
    assert length(Decisions.matching_certainties(choice, person)) == 1
    assert Decisions.matching_certainties(choice, person) == expected_result
  end

  test "does not match a choice when it contains the character in position" do
    person = %Person{id: 1, genes: "aaaa"}
    choice = [%{
      "name"=> "Only for B",
      "chance"=> 0,
      "modifiers"=> [%{
        "position"=> 0,
        "match"=> "B",
        "weight"=> 0
      },
      %{
        "position"=> 0,
        "match"=> "C",
        "weight"=> 1
        }]
    }]

    expected_result = [%{
      "name"=> "Only for B",
      "chance"=> 0,
      "modifiers"=> []
    }]
    assert Decisions.matching_certainties(choice, person) == expected_result
  end

  test "returns a choice when it contains a modifier with weight 0" do
    choice = [%{
      "name"=> "Only for B",
      "chance"=> 0,
      "modifiers"=> [%{
        "position"=> 0,
        "match"=> "B",
        "weight"=> 0
      },
      %{
        "position"=> 0,
        "match"=> "C",
        "weight"=> 1
        }]
    }]
    assert Decisions.modifiers_with_certainty(choice) == [%{"chance" => 0, "modifiers" => [%{"match" => "B", "position" => 0, "weight" => 0}], "name" => "Only for B"}]
  end
end
