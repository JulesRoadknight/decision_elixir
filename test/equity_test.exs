defmodule EquityTest do
  use ExUnit.Case
  doctest Equity

  test "#decisions_equity returns unmodified totals of equity" do
    decisions_path = "test/naturalSelectionFiveDecisions.json"
    assert Equity.unmodified_decisions_equity(decisions_path) == -0.3
  end

  test "#decisions_equity returns 0.0 for neutral equity" do
    decisions_path = "test/twoDecisions.json"
    assert Equity.unmodified_decisions_equity(decisions_path) == 0.0
  end

  test "#person_total_equity returns equity after modifiers (without certainties)" do
    person = %Person{id: 1, genes: "Cmaf", survival_chance: 100}
    decisions_path = "test/naturalSelectionFiveDecisions.json"
    assert Equity.person_total_equity(person, decisions_path) |> Float.round(2) == -2.86
  end

  test "#person_total_equity returns better equity with more favourable genes" do
    person = %Person{id: 1, genes: "jQTZ", survival_chance: 100}
    decisions_path = "test/naturalSelectionFiveDecisions.json"
    assert Equity.person_total_equity(person, decisions_path) |> Float.round(2) == 0.83
  end
end
