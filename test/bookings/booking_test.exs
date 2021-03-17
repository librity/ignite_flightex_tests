defmodule Flightex.Bookings.BookingTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Aux.ValidateUUID
  alias Flightex.Bookings.Booking

  describe "build/4" do
    test "should return a booking when params are valid" do
      return = Booking.build("2021-03-17 08:00:00", "Bujumbura", "Maputo", build(:user))

      assert {:ok,
              %Booking{
                id: uuid,
                departure: _departure,
                leaving_from: _leaving_from,
                going_to: _going_to,
                user_id: _user_id
              }} = return

      assert {:ok, _valid_uuid} = ValidateUUID.call(uuid)
    end

    test "should return a booking with passed uuid" do
      passed_uuid = UUID.uuid4()

      return =
        Booking.build("2021-03-17 08:00:00", "Bujumbura", "Maputo", build(:user), passed_uuid)

      assert {:ok,
              %Booking{
                id: uuid,
                departure: _departure,
                leaving_from: _leaving_from,
                going_to: _going_to,
                user_id: _user_id
              }} = return

      assert passed_uuid == uuid
    end

    test "should return an error when uuid isn't valid" do
      bad_uuid = "SOFUNKY"
      return = Booking.build("2021-03-17 08:00:00", "Bujumbura", "Maputo", build(:user), bad_uuid)

      expected = {:error, "Invalid argument; Not a valid UUID: sofunky"}

      assert expected == return
    end

    test "should return an error when user's uuid isn't valid" do
      bad_uuid = "MUCHHATE"

      return =
        Booking.build("2021-03-17 08:00:00", "Bujumbura", "Maputo", build(:user, id: bad_uuid))

      expected = {:error, "Invalid argument; Not a valid UUID: muchhate"}

      assert expected == return
    end

    test "should return an error when departure date isn't valid" do
      return = Booking.build("202-03-17 08:00:00", "Bujumbura", "Maputo", build(:user))

      expected = {:error, :invalid_format}

      assert expected == return
    end

    test "should return an error when departure_string isn't a bitstring" do
      return = Booking.build(123, "Bujumbura", "Maputo", build(:user))

      expected = {:error, "Invalid params."}

      assert expected == return
    end

    test "should return an error when leaving_from isn't a bitstring" do
      return = Booking.build("2021-03-17 08:00:00", 123, "Maputo", build(:user))

      expected = {:error, "Invalid params."}

      assert expected == return
    end

    test "should return an error when going_to isn't a bitstring" do
      return = Booking.build("2021-03-17 08:00:00", "Bujumbura", 123, build(:user))

      expected = {:error, "Invalid params."}

      assert expected == return
    end

    test "should return an error when user_id isn't a bitstring" do
      return = Booking.build("2021-03-17 08:00:00", "Bujumbura", "Maputo", build(:user, id: 123))

      expected = {:error, "Invalid params."}

      assert expected == return
    end

    test "should return an error when user isn't a struct" do
      return = Booking.build("2021-03-17 08:00:00", "Bujumbura", "Maputo", build(:user_params))

      expected = {:error, "Invalid params."}

      assert expected == return
    end

    test "should return an error when id isn't a bitstring" do
      return = Booking.build("2021-03-17 08:00:00", "Bujumbura", "Maputo", build(:user), 123)

      expected = {:error, "Invalid params."}

      assert expected == return
    end
  end
end
