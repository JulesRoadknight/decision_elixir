defmodule Decisions do
  def make_decision(_person, decisions_path) do
    { _status, decisions_list} = get_decisions(decisions_path)
    evaluate_choices(decisions_list)
  end

  defp get_decisions(decisions_path) do
    with {:ok, contents} <- File.read("./lib/decisions/" <> decisions_path),
      {:ok, json} <- Jason.decode(contents), do: {:ok, json}
  end

  defp evaluate_choices(decisions) do
    if length(decisions) > 0 do
      sum_choices(decisions, 0)
    else
      "Do nothing"
    end
  end

  defp sum_choices(decisions, total_chance) do
    for choice <- decisions do
      sum_choices(decisions, total_chance + choice[:chance])
    end
  end
end
