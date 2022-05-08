defmodule DecisionElixirWeb.PageControllerTest do
  use DecisionElixirWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Decision!"
  end
end
