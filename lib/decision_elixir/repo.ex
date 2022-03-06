defmodule DecisionElixir.Repo do
  use Ecto.Repo,
    otp_app: :decision_elixir,
    adapter: Ecto.Adapters.Postgres
end
