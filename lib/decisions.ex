defmodule Decisions do
  def make_decision(person, decisions_path) do
    { _status, decisions_list } = get_decisions(decisions_path)
    evaluate_choices(person, decisions_list)
  end

  def get_decisions(decisions_path) do
    with {:ok, contents} <- File.read("./lib/decisions/" <> decisions_path),
      {:ok, json} <- Jason.decode(contents), do: {:ok, json}
  end

  defp evaluate_choices(person, decisions) do
    if length(decisions) > 0 do
      check_for_certainties(person, decisions) ||
      apply_modifiers(person, decisions) |> sum_choices |> :rand.uniform |> decision_result(apply_modifiers(person, decisions))
    else
      "Do nothing"
    end
  end

  def apply_modifiers(person, decisions) do
    Enum.map(decisions, fn decision ->
      if Map.has_key?(decision, "modifiers") do
        update_in(
          decision["chance"],
          &(&1 + matching_modifiers(person, decision["modifiers"])))
      else
        decision
      end
    end)
  end

  def matching_modifiers(person, modifiers) do
    Enum.reduce_while(modifiers, 0, fn modifier, acc ->
      if String.at(person.genes, modifier["position"]) == modifier["match"], do: {:cont, acc + modifier["weight"]}, else: {:cont, acc}
    end)
  end

  def sum_choices(decisions) do
    Enum.reduce(decisions, 0, fn choice, acc -> choice["chance"] + acc end)
  end

  def decision_result(result, decisions) do
    Enum.reduce_while(decisions, 0, fn choice, acc ->
      if choice["chance"] + acc < result, do: {:cont, acc + choice["chance"]}, else: {:halt, choice["name"]}
    end)
  end

  def check_for_certainties(person, decisions) do
    final_matches = choices_with_modifiers(decisions) |>
    modifiers_with_certainty() |>
    matching_certainties(person) |>
    remaining_choices()
    if length(final_matches) > 0 do
      List.first(final_matches)["name"]
    end
  end

  def choices_with_modifiers(decisions) do
    Enum.filter(decisions, fn choice ->
      choice["modifiers"]
    end)
  end

  def modifiers_with_certainty(decisions) do
    update_in(decisions, [Access.all(), "modifiers"],
      &Enum.filter(&1, fn modifier -> modifier["weight"] == 0 end))
  end

  def matching_certainties(certainties, person) do
    update_in(certainties, [Access.all(), "modifiers"],
      &Enum.filter(&1, fn modifier -> String.at(person.genes, modifier["position"]) == modifier["match"] end))
  end

  def remaining_choices(choices) do
    Enum.filter(choices, fn match ->
      length(match["modifiers"]) > 0
    end)
  end
end
