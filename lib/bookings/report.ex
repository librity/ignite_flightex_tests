defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate(from_date_string, to_date_string, filename \\ "bookings_report") do
    with {:ok, from_date} <- NaiveDateTime.from_iso8601(from_date_string),
         {:ok, to_date} <- NaiveDateTime.from_iso8601(to_date_string),
         {:ok, bookings_report} <- build_report(from_date, to_date) do
      save_file(filename, bookings_report)
    else
      error -> error
    end
  end

  defp save_file(filename, bookings_report) do
    "reports/#{filename}.csv"
    |> File.write!(bookings_report)

    {:ok, "Report succesfully created."}
  end

  defp build_report(from_date, to_date) do
    report =
      BookingAgent.get_all()
      |> Map.values()
      |> Stream.filter(&filter_by_date(&1, from_date, to_date))
      |> Enum.map(&build_line/1)

    {:ok, report}
  end

  defp filter_by_date(%Booking{departure: departure}, from_date, to_date) do
    (NaiveDateTime.compare(departure, from_date) == :gt or
       NaiveDateTime.compare(departure, from_date) == :eq) and
      (NaiveDateTime.compare(departure, to_date) == :lt or
         NaiveDateTime.compare(departure, to_date) == :eq)
  end

  defp build_line(%Booking{
         user_id: user_id,
         leaving_from: leaving_from,
         going_to: going_to,
         departure: departure
       }) do
    formated_departure = NaiveDateTime.to_string(departure)

    "#{user_id},#{leaving_from},#{going_to},#{formated_departure}\n"
  end
end
