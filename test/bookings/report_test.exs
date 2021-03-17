defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Users.Agent, as: UserAgent

  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Report

  describe "generate/3" do
    setup do
      Flightex.start_agents()

      user_id = UUID.uuid4()

      generate_bookings!(build_list(5, :user), ~N[2013-02-05 23:59:59])
      generate_bookings!(build_list(4, :user, id: user_id), ~N[2014-02-05 23:59:59])
      generate_bookings!(build_list(2, :user), ~N[2014-03-05 23:59:59])

      {:ok, user_id: user_id}
    end

    test "should filter bookings by date and save them as 'reports/bookings_report.csv'", %{
      user_id: user_id
    } do
      return = Report.generate("2014-01-22 23:50:07", "2014-03-04 23:59:59")

      expected_report =
        "#{user_id},LAX,Tokyo,2014-02-05 23:59:59\n" <>
          "#{user_id},LAX,Tokyo,2014-02-05 23:59:59\n" <>
          "#{user_id},LAX,Tokyo,2014-02-05 23:59:59\n" <>
          "#{user_id},LAX,Tokyo,2014-02-05 23:59:59\n"

      assert {:ok, "Report succesfully created."} == return
      assert expected_report == File.read!("reports/bookings_report.csv")
    end

    test "should return an error when dates aren't valid" do
      first_return = Report.generate("201-01-22 23:50:07", "2014-03-04 23:59:59")
      second_return = Report.generate("2015-01-22 23:50:07", "SOFUNKY")

      assert {:error, :invalid_format} == first_return
      assert {:error, :invalid_format} == second_return
    end

    test "should filter bookings by date and save them as an arbitrary file", %{
      user_id: user_id
    } do
      return = Report.generate("2014-01-22 23:50:07", "2014-03-04 23:59:59", "testing123")

      expected_report =
        "#{user_id},LAX,Tokyo,2014-02-05 23:59:59\n" <>
          "#{user_id},LAX,Tokyo,2014-02-05 23:59:59\n" <>
          "#{user_id},LAX,Tokyo,2014-02-05 23:59:59\n" <>
          "#{user_id},LAX,Tokyo,2014-02-05 23:59:59\n"

      assert {:ok, "Report succesfully created."} == return
      assert expected_report == File.read!("reports/testing123.csv")
    end
  end

  defp generate_bookings!(users, departure_date) do
    users
    |> Stream.map(fn user -> UserAgent.save(user) end)

    users
    |> Enum.map(fn user ->
      BookingAgent.save(build(:booking, user_id: user.id, departure: departure_date))
    end)
  end
end
