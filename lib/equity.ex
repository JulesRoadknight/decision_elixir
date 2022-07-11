defmodule Equity do

  def unmodified_decisions(decisions_path) do
    { _status, decisions_list } = Decisions.get_decisions(decisions_path)
    Enum.reduce(decisions_list, 0, fn decision, acc -> decision["chance"] * Results.match_decision_result(decision["name"], decisions_path) + acc end)
    / Decisions.sum_chance_of_choices(decisions_list)
  end

  def person_total(person, decisions_path) do
    { _status, decisions_list } = Decisions.get_decisions(decisions_path)
    updated_decisions = Decisions.apply_modifiers(person, decisions_list)
    Enum.reduce(updated_decisions, 0, fn decision, acc -> decision["chance"] * Results.match_decision_result(decision["name"], decisions_path) + acc end)
    / Decisions.sum_chance_of_choices(updated_decisions)
  end

  def population_average(population, decisions_path) do
    Enum.reduce(population, 0, fn person, acc -> person_total(person, decisions_path) + acc end)
    / length(population)
  end

  def population_beating_unmodified(population, decisions_path) do
    population_average(population, decisions_path) > unmodified_decisions(decisions_path)
  end
end
