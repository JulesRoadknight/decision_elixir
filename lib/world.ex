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

    defp survives?(person) do
      person.survival_chance >= 50
    end

  def reproduction_check(state) do
    if state["reproduction_frequency"] == state["world"]["turn"] do
      offspring = pair_off_reproduction(state["world"]["population"], state["agents_total"])
      update_in(state, ["world", "population"],
        &Enum.concat(&1, offspring))|>
      update_in(["agents_total"],
        &(&1 + length(offspring)))
    else
      state
    end
  end

  def pair_off_reproduction(population, agents_total) do
    Enum.shuffle(population) |>
    Enum.chunk_every(2, 2, :discard) |>
      pair_off_loop(agents_total, [])
  end

  def pair_off_loop([first_pair | remaining_pairs], agents_total, children) do
    child = Reproduction.standard_reproduction(first_pair, agents_total)
    if length(remaining_pairs) > 0 do
      pair_off_loop(remaining_pairs, agents_total + 1, [child | children])
    else
      Enum.reverse([child | children])
    end
  end

  def tick(state) do
    update_in(state["world"]["turn"], &(&1 + 1))
  end
end
