defmodule World do
  def take_turn(state) do
    make_decisions(state) |>
    apply_survival_tick |>
    tick
  end

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

  defp tick(state) do
    update_in(state["world"]["turn"], &(&1 + 1))
  end
end
