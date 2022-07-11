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
    assert Decisions.make_decision(person, decisions_path) == "Certainty for B"
  end

  test "choices with modifiers removes choices without modifiers" do
    decisions_path = "test/fixedWhenFirstB.json"
    { _status, decisions } = Decisions.get_decisions(decisions_path)

    expected_result = [%{
      "name" => "Certainty for B",
      "chance" => 0,
      "modifiers" => [%{
        "position" => 0,
        "match" => "B",
        "weight" => 0
      },
      %{
        "position" => 0,
        "match" => "C",
        "weight" => 10
      }]
    }]

    assert Decisions.choices_with_modifiers(decisions) == expected_result
  end

  test "modifiers with certainty only returns certainties" do
    input = [%{
      "name" => "Certainty for B",
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
      "name" => "Certainty for B",
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
      "name" => "Certainty for B",
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
          "name" => "Certainty for B",
          "chance" => 0,
          "modifiers" => [%{
            "position" => 0,
            "match" => "B",
            "weight" => 0
          },
          %{
              "position" => 0,
              "match" => "C",
              "weight" => 10
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
      "name"=> "Certainty for B",
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
      "name"=> "Certainty for B",
      "chance"=> 0,
      "modifiers"=> []
    }]
    assert Decisions.matching_certainties(choice, person) == expected_result
  end

  test "returns a choice when it contains a modifier with weight 0" do
    choice = [%{
      "name"=> "Certainty for B",
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
    assert Decisions.modifiers_with_certainty(choice) == [%{"chance" => 0, "modifiers" => [%{"match" => "B", "position" => 0, "weight" => 0}], "name" => "Certainty for B"}]
  end

  test "can increase the chance of an 0 chance choice" do
    person = %Person{id: 1, genes: "Caaa"}
    decisions_path = "test/fixedWhenFirstB.json"
    assert Decisions.make_decision(person, decisions_path) in ["Not B", "Certainty for B"]
  end

  test "has an increased chance when the modifier matches" do
    person = %Person{id: 1, genes: "Aaaa"}
    decisions_path = "test/modifiesForA.json"
    assert Decisions.make_decision(person, decisions_path) == "Not Unless Modified"
  end

  test "has a decreased chance when the modifier matches" do
    person = %Person{id: 1, genes: "Zaaa"}
    decisions_path = "test/modifiesNegatively.json"
    assert Decisions.make_decision(person, decisions_path) == "Not Unless Modified"
  end

  test "#matching_modifiers can apply negative modifiers" do
    person = %Person{id: 1, genes: "ZaBa"}
    modifiers = [%{
      "position" => 0,
      "match" => "Z",
      "weight" => -1
    }]

    assert Decisions.matching_modifiers(person, modifiers) == -1
  end

  test "#matching_modifiers can apply multiple modifiers" do
    person = %Person{id: 1, genes: "AaBa"}
    modifiers = [%{
      "position" => 0,
      "match" => "A",
      "weight" => 1
    },
    %{
      "position" => 2,
      "match" => "B",
      "weight" => 9
    }]

    assert Decisions.matching_modifiers(person, modifiers) == 10
  end

  test "#matching_modifiers can match from a range" do
    person = %Person{id: 1, genes: "D"}
    modifiers = [%{
      "position" => 0,
      "match" => "[A-E]",
      "weight" => 99
    }]

    assert Decisions.matching_modifiers(person, modifiers) == 99
  end

  test "#matching_modifiers can match from multiple ranges" do
    person = %Person{id: 1, genes: "yz"}
    modifiers = [%{
      "position" => 0,
      "match" => "[A-E|x-z]",
      "weight" => 15
    },
    %{
      "position" => 1,
      "match" => "[A-b|d-i|xyz]",
      "weight" => 200
    }]

    assert Decisions.matching_modifiers(person, modifiers) == 215
  end

  test "#matching_modifiers can match multiple positions" do
    person = %Person{id: 1, genes: "Daaaaa"}
    modifiers = [%{
      "position" => 0,
      "match" => "[A-E]",
      "weight" => 99
    }]

    assert Decisions.matching_modifiers(person, modifiers) == 99
  end

  test "#apply_modifiers does not update chance when no modifiers" do
    person = %Person{id: 1, genes: "AaBa"}
    decisions = [%{
      "name" => "Not Unless Modified",
      "chance" => 1,
    }]
    assert Decisions.apply_modifiers(person, decisions) == decisions
  end
end
