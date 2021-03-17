defmodule Flightex.Bookings.AgentTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  describe "save/1" do
    setup do
      BookingAgent.start_link()

      :ok
    end

    test "should persist booking in agent" do
      valid_booking = build(:booking)

      expected_booking = %{
        valid_booking.id => %Booking{
          id: valid_booking.id,
          departure: NaiveDateTime.from_iso8601!("2014-03-04 23:59:59"),
          leaving_from: "LAX",
          going_to: "Tokyo",
          user_id: valid_booking.user_id
        }
      }

      assert :ok == BookingAgent.save(valid_booking)
      assert expected_booking == Agent.get(Flightex.Bookings.Agent, & &1)
    end
  end

  describe "get/1" do
    setup do
      BookingAgent.start_link()

      valid_booking = build(:booking)
      BookingAgent.save(valid_booking)

      {:ok, valid_booking: valid_booking}
    end

    test "should return booking by id", %{valid_booking: %Booking{id: id, user_id: user_id}} do
      expected =
        {:ok,
         %Booking{
           id: id,
           departure: NaiveDateTime.from_iso8601!("2014-03-04 23:59:59"),
           leaving_from: "LAX",
           going_to: "Tokyo",
           user_id: user_id
         }}

      assert expected == BookingAgent.get(id)
    end

    test "should return an error when booking doesn't exist" do
      expected = {:error, "Booking not found."}

      assert expected == BookingAgent.get(UUID.uuid4())
    end
  end

  describe "get_all/0" do
    setup do
      BookingAgent.start_link()

      bookings = build_list(3, :booking)

      bookings
      |> Enum.map(fn booking -> BookingAgent.save(booking) end)

      {:ok, bookings: bookings}
    end

    test "should return all bookings", %{bookings: bookings} do
      expected =
        bookings
        |> Enum.reduce(%{}, fn %Booking{id: booking_id} = booking, previous ->
          Map.put(previous, booking_id, booking)
        end)

      assert expected == BookingAgent.get_all()
    end
  end
end
