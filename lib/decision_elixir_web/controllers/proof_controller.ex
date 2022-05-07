defmodule DecisionElixirWeb.ProofController do
  use DecisionElixirWeb, :controller

  plug :action

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
