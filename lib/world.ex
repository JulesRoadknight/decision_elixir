defmodule World do
  def make_decisions(state) do
    update_in(state["world"]["population"],
      &population_decision_loop(&1, state["decisions"])
    )
  end

  defp population_decision_loop(population, decisions_path) do
    Enum.reduce(population, [], fn person, acc ->
      [%Person{person | survival_chance: person.survival_chance + Results.decision_and_result(person, decisions_path)} | acc ]
    end) |> Enum.reverse()
  end

  def apply_survival_tick(state) do
    update_in(state["world"]["population"],
      &survival_tick_loop(&1)
    )
  end

  defp survival_tick_loop(population) do
    Enum.reduce(population, [], fn person, acc ->
      [%Person{person | survival_chance: person.survival_chance - 1} | acc ]
    end) |> Enum.reverse()
  end

  def survival_check(state) do
    update_in(state["world"]["population"],
      &Enum.filter(&1, fn person -> survives?(person) end)
    )
  end

  def reproduction_check(state) do
    if state["reproduction_frequency"] == state["world"]["turn"] do
      update_in(state["world"]["population"],
        &pair_off_reproduction(&1, state["agents_total"])
      )
    else
      state
    end
  end

  defp pair_off_reproduction(population, agents_total) do
    offspring = Enum.shuffle(population) |>
    Enum.chunk_every(2) |>
    Enum.map(
      &Reproduction.standard_reproduction(
        &1,
        agents_total))
    Enum.concat(population, offspring)
  end

  defp survives?(person) do
    person.survival_chance >= 50
  end

  def tick(state) do
    update_in(state["world"]["turn"], &(&1 + 1))
  end
end
