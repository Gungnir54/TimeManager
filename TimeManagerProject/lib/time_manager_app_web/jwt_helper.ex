defmodule TimeManagerWeb.JWTHelper do
  use Joken.Config

    @secret_key Application.get_env(:time_manager, :jwt_secret)
  def create_token(user) do
    IO.inspect(user, label: "Contenu de user dans create_token")

    csrf_token = generate_csrf_token()

    claims = %{
      "user_id" => user.id,
      "c-xsrf-token" => csrf_token
    }

    signer = Joken.Signer.create("HS256", @secret_key)
    {:ok, token, _claims} = Joken.encode_and_sign(claims, signer)

    {:ok, token}
  end

  # Vérification du token
  def verify_token(token) do
    signer = Joken.Signer.create("HS256", @secret_key)
    case Joken.verify_and_validate(%{}, token, signer) do
      {:ok, claims} ->
        {:ok, claims}
      {:error, reason} ->
        {:error, reason}
    end
  end

  # Génération du CSRF token
  defp generate_csrf_token do
    :crypto.strong_rand_bytes(16) |> Base.encode64()
  end
end
