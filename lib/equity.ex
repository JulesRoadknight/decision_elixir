defmodule Equity do

  def decisions_equity(decisions_path) do
    { _status, decisions_list } = Decisions.get_decisions(decisions_path)
    Enum.reduce(decisions_list, 0, fn decision, acc -> decision["chance"] * Results.match_decision_result(decision["name"], decisions_path) + acc end) /
    Decisions.sum_chance_of_choices(decisions_list)
  end
end
