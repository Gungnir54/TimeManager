defmodule TimeManagerWeb.Plugs.VerifyJWT do
  import Plug.Conn

  alias TimeManagerWeb.JWTHelper
  alias Joken.Signer

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case JWTHelper.verify_token(token) do
          {:ok, claims} ->
            conn
            |> assign(:claims, claims)
          {:error, _reason} ->
            conn
            |> send_resp(:unauthorized, "Invalid token")
            |> halt()
        end

      _ ->
        conn
        |> send_resp(:unauthorized, "Missing token")
        |> halt()
    end
  end
end