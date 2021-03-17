defmodule Flightex.Bookings.Create do
  alias Flightex.Users.Agent, as: UserAgent

  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def call(user_id, %{
        departure: departure,
        leaving_from: leaving_from,
        going_to: going_to
      }) do
    with {:ok, user} <- UserAgent.get(user_id),
         {:ok, booking} <- Booking.build(departure, leaving_from, going_to, user) do
      save_booking(booking)
    else
      error -> error
    end
  end

  defp save_booking(%Booking{id: booking_id} = booking) do
    BookingAgent.save(booking)

    {:ok, booking_id}
  end
end
