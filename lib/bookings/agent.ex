defmodule Flightex.Bookings.Agent do
  use Agent

  alias Flightex.Bookings.Booking

  def start_link(_initial_value \\ %{}) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%Booking{} = booking), do: Agent.update(__MODULE__, &insert_booking(&1, booking))

  def get(id), do: Agent.get(__MODULE__, &fetch_booking(&1, id))
  def get_all, do: Agent.get(__MODULE__, & &1)

  defp insert_booking(previous_state, %Booking{id: id} = booking),
    do: Map.put(previous_state, id, booking)

  defp fetch_booking(previous_state, id) do
    case Map.get(previous_state, id) do
      nil -> {:error, "Booking not found."}
      booking -> {:ok, booking}
    end
  end
end
