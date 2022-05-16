defmodule Decisions do
  def make_decision(_person, decisions_path) do
    { _status, decisions_list } = get_decisions(decisions_path)
    evaluate_choices(decisions_list)
  end

  def get_decisions(decisions_path) do
    with {:ok, contents} <- File.read("./lib/decisions/" <> decisions_path),
      {:ok, json} <- Jason.decode(contents), do: {:ok, json}
  end

  defp evaluate_choices(decisions) do
    if length(decisions) > 0 do
      sum_choices(decisions) |> :rand.uniform |> decision_result(decisions)
    else
      "Do nothing"
    end
  end

  def sum_choices(decisions) do
    Enum.reduce(decisions, 0, fn choice, acc -> choice["chance"] + acc end)
  end

  def decision_result(result, decisions) do
    Enum.reduce_while(decisions, 0, fn choice, acc ->
      if choice["chance"] + acc < result, do: {:cont, acc + choice["chance"]}, else: {:halt, choice["name"]}
    end)
  end
end
