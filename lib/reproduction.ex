defmodule Reproduction do
  def standard_reproduction(parents, agent_total) do
    %Person{
      id: agent_total + 1,
      genes: half_genes(Enum.at(parents, 0).genes, 0)<>half_genes(Enum.at(parents, 1).genes, 1),
      survival_chance: 60}
  end

  defp half_genes(genes, which_half) do
    String.split_at(genes, trunc(String.length(genes) / 2)) |> elem(which_half)
  end
end
