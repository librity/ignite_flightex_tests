defmodule Flightex.Bookings.Booking do
  alias Flightex.Aux.ValidateUUID

  alias Flightex.Users.User

  @keys [:id, :departure, :leaving_from, :going_to, :user_id]
  @enforce_keys @keys

  defstruct @keys

  def build(departure_string, leaving_from, going_to, user, id \\ UUID.uuid4())

  def build(departure_string, leaving_from, going_to, %User{id: user_id}, id)
      when is_bitstring(departure_string) and
             is_bitstring(leaving_from) and
             is_bitstring(going_to) and
             is_bitstring(user_id) do
    with {:ok, departure_date} <- NaiveDateTime.from_iso8601(departure_string),
         {:ok, valid_user_id} <- ValidateUUID.call(user_id),
         {:ok, valid_id} <- ValidateUUID.call(id) do
      build_booking(departure_date, leaving_from, going_to, valid_user_id, valid_id)
    else
      error -> error
    end
  end

  def build(_departure, _leaving_from, _going_to, _user_id, _id), do: {:error, "Invalid params."}

  def build_booking(departure_date, leaving_from, going_to, user_id, id) do
    {:ok,
     %__MODULE__{
       id: id,
       departure: departure_date,
       leaving_from: leaving_from,
       going_to: going_to,
       user_id: user_id
     }}
  end
end
