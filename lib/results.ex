defmodule Results do
  def decision_and_result(person, decisions_path) do
    Decisions.make_decision(person, decisions_path) |> match_decision_result(decisions_path)
  end

  def match_decision_result(decision, decisions_path) do
    if decision == "Do nothing" do
      0
    else
      { _status, results_list } = get_results(decisions_path)
      find_match(decision, results_list)
    end
  end

  defp get_results(decisions_path) do
    with {:ok, contents} <- File.read("./lib/results/" <> decisions_path),
      {:ok, json} <- Jason.decode(contents), do: {:ok, json}
  end

  defp find_match(decision, results) do
    Enum.reduce_while(results, 0, fn result, acc ->
      if result["name"] == decision, do: {:halt, result["result"]}, else: {:cont, acc}
    end)
  end
end
