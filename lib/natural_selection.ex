defmodule NaturalSelection do
  def run(state) do
      World.make_decisions(state) |>
      World.apply_survival_tick |>
      World.survival_check |>
      World.reproduction_check |>
      World.tick
  end
end
