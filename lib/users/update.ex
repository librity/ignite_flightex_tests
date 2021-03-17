defmodule Flightex.Users.Update do
  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.User

  def call(id, %{name: name, email: email, cpf: cpf}) do
    with {:ok, _old_user} <- UserAgent.get(id),
         {:ok, updated_user} <- User.build(name, email, cpf, id) do
      save_user(updated_user)
    else
      error -> error
    end
  end

  defp save_user(%User{id: user_id} = user) do
    UserAgent.save(user)

    {:ok, user_id}
  end
end
