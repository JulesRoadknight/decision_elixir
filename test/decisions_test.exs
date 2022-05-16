defmodule DecisionsTest do
  use ExUnit.Case
  doctest Decisions

  test "it makes a decision when there is no decision" do
    person = %Person{id: 1, genes: "aaaa"}
    decisions = "blankDecisions.json"
    assert Decisions.make_decision(person, decisions) == "Do nothing"
  end

  test "it makes a decision when there is one decision" do
    person = %Person{id: 1, genes: "aaaa"}
    decisions = "oneDecision.json"
    assert Decisions.make_decision(person, decisions) == "Win"
  end

  test "it makes a different decision when there is one decision" do
    person = %Person{id: 1, genes: "aaaa"}
    decisions = "oneOtherDecision.json"
    assert Decisions.make_decision(person, decisions) == "Lose"
  end

  test "it makes a decision when there are two decisions" do
    person = %Person{id: 1, genes: "aaaa"}
    decisions = "twoDecisions.json"
    assert Decisions.make_decision(person, decisions) in ["Win", "Lose"]
  end

  test "sums total choice of decisions" do
    person = %Person{id: 1, genes: "aaaa"}
    decisions = "twoDecisions.json"
    { _status, decisions_list} = Decisions.get_decisions(decisions)
    assert Decisions.sum_choices(decisions_list) == 1010
  end

  test "finds matching result of decision" do
    person = %Person{id: 1, genes: "aaaa"}
    decisions = "twoDecisions.json"
    { _status, decisions_list} = Decisions.get_decisions(decisions)
    assert Decisions.decision_result(10, decisions_list) == "Win"
  end

  test "finds other matching result of decision" do
    person = %Person{id: 1, genes: "aaaa"}
    decisions = "twoDecisions.json"
    { _status, decisions_list} = Decisions.get_decisions(decisions)
    assert Decisions.decision_result(1010, decisions_list) == "Lose"
  end
end
