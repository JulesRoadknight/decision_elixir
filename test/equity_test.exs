defmodule EquityTest do
  use ExUnit.Case
  doctest Equity

  test "#unmodified_decisions returns unmodified totals of equity" do
    decisions_path = "test/naturalSelectionFiveDecisions.json"
    assert Equity.unmodified_decisions(decisions_path) == -0.3
  end

  test "#unmodified_decisions returns 0.0 for neutral equity" do
    decisions_path = "test/twoDecisions.json"
    assert Equity.unmodified_decisions(decisions_path) == 0.0
  end

  test "#person_total returns equity after modifiers (without certainties)" do
    person = %Person{id: 1, genes: "Cmaf", survival_chance: 100}
    decisions_path = "test/naturalSelectionFiveDecisions.json"
    assert Equity.person_total(person, decisions_path) |> Float.round(2) == -2.86
  end

  test "#person_total returns better equity with more favourable genes" do
    person = %Person{id: 1, genes: "jQTZ", survival_chance: 100}
    decisions_path = "test/naturalSelectionFiveDecisions.json"
    assert Equity.person_total(person, decisions_path) |> Float.round(2) == 0.83
  end

  test "#population_average returns average equity of a list of players" do
    population = [%Person{id: 1, genes: "jQTZ", survival_chance: 100}, %Person{id: 1, genes: "Cmaf", survival_chance: 100}]
    decisions_path = "test/naturalSelectionFiveDecisions.json"
    assert Equity.population_average(population, decisions_path) |> Float.round(2) == -1.02
  end

  test "#population_beating_unmodified returns true if population outperforms unmodified equity" do
    population = [
      %Person{id: 1, genes: "jQTZ", survival_chance: 100},
      %Person{id: 1, genes: "jQTZ", survival_chance: 100},
      %Person{id: 1, genes: "jQTZ", survival_chance: 100},
      %Person{id: 1, genes: "Cmaf", survival_chance: 100}]
    decisions_path = "test/naturalSelectionFiveDecisions.json"
    assert Equity.population_beating_unmodified(population, decisions_path) == true
  end

  test "#population_beating_unmodified returns false if population underperforms (or matches) unmodified equity" do
    population = [%Person{id: 1, genes: "jQTZ", survival_chance: 100}, %Person{id: 1, genes: "Cmaf", survival_chance: 100}]
    decisions_path = "test/naturalSelectionFiveDecisions.json"
    assert Equity.population_beating_unmodified(population, decisions_path) == false
  end
end
