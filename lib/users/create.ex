defmodule Flightex.Users.Create do
  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.User

  def call(%{name: name, email: email, cpf: cpf}) do
    name
    |> User.build(email, cpf)
    |> save_user()
  end

  defp save_user({:ok, %User{id: user_id} = user}) do
    UserAgent.save(user)

    {:ok, user_id}
  end

  defp save_user({:error, _reason} = error), do: error
end
