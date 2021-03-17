defmodule Flightex.Bookings.UpdateTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Users.Agent, as: UserAgent

  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking
  alias Flightex.Bookings.Create
  alias Flightex.Bookings.Update

  describe "call/3" do
    setup do
      UserAgent.start_link()
      BookingAgent.start_link()

      {:ok, user_id} =
        build(:user_params)
        |> Flightex.Users.Create.call()

      {:ok, booking_id} =
        user_id
        |> Create.call(build(:booking_params))

      {:ok, user_id: user_id, booking_id: booking_id}
    end

    test "should update the booking and return its id", %{
      user_id: user_id,
      booking_id: booking_id
    } do
      new_params =
        build(:booking_params,
          departure: "2022-03-04 03:47:00",
          leaving_from: "Kabul",
          going_to: "Cleveland"
        )

      return = Update.call(booking_id, user_id, new_params)

      expected_booking = %Booking{
        id: booking_id,
        departure: NaiveDateTime.from_iso8601!("2022-03-04 03:47:00"),
        leaving_from: "Kabul",
        going_to: "Cleveland",
        user_id: user_id
      }

      assert {:ok, returned_id} = return
      assert booking_id == returned_id
      assert {:ok, updated_booking} = BookingAgent.get(booking_id)
      assert expected_booking == updated_booking
    end

    test "should return an error when params aren't valid", %{
      user_id: user_id,
      booking_id: booking_id
    } do
      new_params = build(:booking_params, going_to: 123)

      return = Update.call(booking_id, user_id, new_params)

      assert {:error, "Invalid params."} == return
    end

    test "should return an error when booking doesn't exist", %{user_id: user_id} do
      new_params =
        build(:booking_params,
          name: "Jesse James",
          email: "jesse@younger.org",
          cpf: "632-645-5215"
        )

      return = Update.call(UUID.uuid4(), user_id, new_params)

      assert {:error, "Booking not found."} == return
    end

    test "should return an error when user doesn't exist", %{booking_id: booking_id} do
      new_params =
        build(:booking_params,
          name: "Jesse James",
          email: "jesse@younger.org",
          cpf: "632-645-5215"
        )

      return = Update.call(booking_id, UUID.uuid4(), new_params)

      assert {:error, "User not found."} == return
    end
  end
end
