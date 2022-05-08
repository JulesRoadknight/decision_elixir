defmodule WorldTest do
  use ExUnit.Case
  doctest World

  test "it ticks iteratively" do
    assert World.tick(0) == 1
  end

  test "it has a population" do
    person = %Person{}
    assert World.population([person]) == 1
  end

  test "it returns the state including the turn number at the end of a turn" do
    assert World.take_turn(%{"current_turn" => 0})["current_turn"] == 1
  end

  test "it tracks the turn number" do
    assert World.take_turn(%{"current_turn" => 99})["current_turn"] == 100
  end

  test "it returns no population when none was given" do
    assert World.take_turn(%{"current_turn" => 0, "population" => []})["population"] == []
  end

  test "it returns the same population as was given" do
    person = %Person{id: 1, genes: :aaaa}
    assert World.take_turn(%{"current_turn" => 0, "population" => [person]})["population"] == [person]
  end
end
