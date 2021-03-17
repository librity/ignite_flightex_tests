defmodule Flightex.Bookings.CreateTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Users.Agent, as: UserAgent

  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Create

  describe "call/2" do
    setup do
      BookingAgent.start_link()
      UserAgent.start_link()

      {:ok, user_id} =
        build(:user_params)
        |> Flightex.Users.Create.call()

      {:ok, user_id: user_id}
    end

    test "should create the booking and return its id", %{user_id: user_id} do
      return =
        user_id
        |> Create.call(build(:booking_params))

      assert {:ok, booking_id} = return
      assert {:ok, _booking} = BookingAgent.get(booking_id)
    end

    test "should return an error when user doesn't exist" do
      return =
        UUID.uuid4()
        |> Create.call(build(:booking_params, departure: 1234))

      assert {:error, "User not found."} == return
    end

    test "should return an error when params aren't valid", %{user_id: user_id} do
      return =
        user_id
        |> Create.call(build(:booking_params, departure: 1234))

      assert {:error, "Invalid params."} == return
    end
  end
end
