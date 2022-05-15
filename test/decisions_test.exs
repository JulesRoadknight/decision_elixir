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
end
