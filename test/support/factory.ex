defmodule Flightex.Factory do
  use ExMachina

  alias Flightex.Bookings.Booking
  alias Flightex.Users.User

  def user_factory do
    %User{
      id: "4545beed-fa92-4794-a544-e6378f1fcb58",
      name: "Iggy Azalea",
      email: "iggy@murderbusiness.org",
      cpf: "1234567"
    }
  end

  def user_params_factory do
    build(:user)
    |> Map.from_struct()
    |> Map.delete(:id)
  end

  def booking_factory do
    %{id: user_id} = build(:user)

    %Booking{
      id: "450adae8-3a94-4634-8c0d-c4b56572e390",
      departure: "2014-03-04 23:59:59",
      leaving_from: "LAX",
      going_to: "Tokyo",
      user_id: user_id
    }
  end

  def booking_params_factory do
    build(:booking)
    |> Map.from_struct()
    |> Map.delete(:id)
    |> Map.delete(:user_id)
  end
end
