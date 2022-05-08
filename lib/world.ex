defmodule World do
  def tick(age) do
    age + 1
  end

  def population(inhabitants) do
    length(inhabitants)
  end

  def take_turn(last_turn_state) do
      %{
        "current_turn" => last_turn_state["current_turn"] |> tick,
        "population" => last_turn_state["population"]
      }
  end
end
