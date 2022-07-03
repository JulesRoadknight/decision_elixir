defmodule World do
  def take_turn(state) do
    population_make_decisions(state) |>
    tick
  end

  def population_make_decisions(state) do
    update_in(state["world"]["population"],
      &apply_survival_tick(&1)
    )
  end

  defp apply_survival_tick(population) do
    Enum.reduce(population, [], fn person, acc ->
      [%Person{person | survival_chance: person.survival_chance - 1} | acc ]
    end) |> Enum.reverse()
  end

  defp tick(state) do
    update_in(state["world"]["turn"], &(&1 + 1))
  end
end
