defmodule ResultsTest do
  use ExUnit.Case
  doctest Results

  test "it returns 0 for Do Nothing" do
    person = %Person{id: 1, genes: "aaaa"}
    decisions_path = "test/blankDecisions.json"
    assert Results.decision_and_result(person, decisions_path) == 0
  end

  test "it returns the value of a matching result" do
    person = %Person{id: 1, genes: "aaaa"}
    decisions_path = "test/oneDecision.json"
    assert Results.decision_and_result(person, decisions_path) == 2
  end

    test "it returns result for a certainty when valid" do
      person = %Person{id: 1, genes: "Baaa"}
      decisions_path = "test/fixedWhenFirstB.json"
      assert Results.decision_and_result(person, decisions_path) == 11
    end

  test "it returns a non-certainty" do
    person = %Person{id: 1, genes: "Faaa"}
    decisions_path = "test/fixedWhenFirstB.json"
    assert Results.decision_and_result(person, decisions_path) == 3
  end
end
