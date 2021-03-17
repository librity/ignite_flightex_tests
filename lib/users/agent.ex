defmodule Flightex.Users.Agent do
  use Agent

  alias Flightex.Users.User

  def start_link(_initial_value \\ %{}) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%User{} = user), do: Agent.update(__MODULE__, &insert_user(&1, user))

  def get(id), do: Agent.get(__MODULE__, &get_user(&1, id))
  def get_all, do: Agent.get(__MODULE__, & &1)

  defp insert_user(previous_state, %User{id: id} = user),
    do: Map.put(previous_state, id, user)

  defp get_user(previous_state, id) do
    case Map.get(previous_state, id) do
      nil -> {:error, "User not found."}
      user -> {:ok, user}
    end
  end
end
