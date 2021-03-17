defmodule Flightex do
  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.Create, as: UserCreator
  alias Flightex.Users.Update, as: UserUpdater

  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Create, as: BookingCreator
  alias Flightex.Bookings.Update, as: BookingUpdater

  def start_agents do
    UserAgent.start_link()
    BookingAgent.start_link()
  end

  defdelegate create_user(params), to: UserCreator, as: :call
  defdelegate update_user(id, params), to: UserUpdater, as: :call
  defdelegate get_user(params), to: UserAgent, as: :get
  defdelegate get_users, to: UserAgent, as: :get_all

  defdelegate create_booking(user_id, params), to: BookingCreator, as: :call
  defdelegate update_booking(booking_id, user_id, params), to: BookingUpdater, as: :call
  defdelegate get_booking(params), to: BookingAgent, as: :get
  defdelegate get_bookings, to: BookingAgent, as: :get_all
end
