defmodule EquityTest do
  use ExUnit.Case
  doctest Equity

  test "#decisions_equity returns unmodified totals of equity" do
    person = %Person{id: 1, genes: "aaaa", survival_chance: 100}
    decisions_path = "test/naturalSelectionFiveDecisions.json"
    assert Equity.decisions_equity(decisions_path) == -0.3
  end
end
