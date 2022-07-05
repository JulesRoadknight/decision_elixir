defmodule Reproduction do
  def pair_off_reproduction(population, agents_total) do
    Enum.shuffle(population) |>
    Enum.chunk_every(2, 2, :discard) |>
      pair_off_loop(agents_total, [])
  end

  def pair_off_loop([first_pair | remaining_pairs], agents_total, children) do
    child = Reproduction.standard_reproduction(first_pair, agents_total)
    if length(remaining_pairs) > 0 do
      pair_off_loop(remaining_pairs, agents_total + 1, [child | children])
    else
      Enum.reverse([child | children])
    end
  end

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
