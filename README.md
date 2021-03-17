# Flightex

## Table of Contents

- [About](#about)
- [Bash Commands](#bash_commands)
- [Elixir Commands](#elixir_commands)
- [Libs](#libs)
- [Docs](#docs)
- [Resources](#resources)

## About <a name = "about"></a>

A demo Elixir program that uses `Structs` as `Data Transfer Objects`,
and `Agents` to persist state between precesses.

Challenge 5 of Ignite Elixir, a bootcamp by Rocket Seat.

## Bash Commands <a name = "bash_commands"></a>

```bash
# Create new Elixir project
$ mix new project_name
# Intall dependencies
$ mix deps.get
# Generate linter config
$ mix credo gen.config
# Run linter
$ mix credo --strict
# Start your project as an Interactive Elixir session
$ iex -S mix
# Run tests
$ mix test
```

## Elixir Commands <a name = "elixir_commands"></a>

Expected behavior:

```elixir
> Flightex.create_user(params)
{:ok, user_id}

> Flightex.create_booking(user_id, params)
{:ok, booking_id}

> Flightex.create_booking(invalid_user_id, params)
{:error, "User not found"}

> Flightex.get_booking(booking_id)
{:ok, %Booking{...}}

> Flightex.get_booking(invalid_booking_id)
{:error, "Flight Booking not found"}

> Flightex.generate_report(from_date, to_date)
{:ok, "Report generated successfully"}
```

Naive Date Time (Date-time without timezone):

```elixir
> NaiveDateTime.from_iso8601("2015-01-23 23:50:07")
{:ok, ~N[2015-01-23 23:50:07]}
> NaiveDateTime.from_iso8601!("2015-01-23 23:50:07")
~N[2015-01-23 23:50:07]
> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: "CET",
>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},
>                utc_offset: 3600, std_offset: 0, time_zone: "Europe/Warsaw"}
#DateTime<2000-02-29 23:00:07+01:00 CET Europe/Warsaw>
> NaiveDateTime.to_erl(dt)
{{2000, 2, 29}, {23, 0, 7}}
```

UUID4 validation:

```elixir
> {:ok, [{:uuid, valid_uuid} | _tails]} = UUID.uuid4() |> UUID.info()
{:ok,
 [
   uuid: "52224694-3cee-48f9-938c-ab99830c2881",
   binary: <<82, 34, 70, 148, 60, 238, 72, 249, 147, 140, 171, 153, 131, 12, 40,
     129>>,
   type: :default,
   version: 4,
   variant: :rfc4122
 ]}
> valid_uuid
"52224694-3cee-48f9-938c-ab99830c2881"
> {:error, message} = "SOFUNKY" |> UUID.info()
{:error, "Invalid argument; Not a valid UUID: sofunky"}
```

User Agent and Creator:

```elixir
> Flightex.start_agents()
> user_params = Flightex.Factory.build(:user)

> {:ok, user_id} = Flightex.create_user(user_params)
{:ok, "9a68c5da-2f51-4e5e-a2b8-21b7dee48105"}

> Flightex.update_user(user_id, user_params)
{:ok, "9a68c5da-2f51-4e5e-a2b8-21b7dee48105"}
> Flightex.update_user("SOFUNKY", user_params)
{:error, "User not found."}

> Flightex.get_user(user_id)
{:ok,
 %Flightex.Users.User{
   cpf: "1234567",
   email: "iggy@murderbusiness.org",
   id: "9a68c5da-2f51-4e5e-a2b8-21b7dee48105",
   name: "Iggy Azalea"
 }}
> Flightex.get_user("SOFUNKY")
{:error, "User not found."}

> Flightex.get_users
%{
  "9a68c5da-2f51-4e5e-a2b8-21b7dee48105" => %Flightex.Users.User{
    cpf: "1234567",
    email: "iggy@murderbusiness.org",
    id: "9a68c5da-2f51-4e5e-a2b8-21b7dee48105",
    name: "Iggy Azalea"
  }
}
```

Booking Agent and Creator:

```elixir
> Flightex.start_agents()
> booking_params = Flightex.Factory.build(:booking_params)
> user_params = Flightex.Factory.build(:user_params)
> {:ok, user_id} = Flightex.create_user(user_params)
{:ok, "02cf4d12-38bc-46fe-9785-af179fd7053f"}

> {:ok, booking_id} = Flightex.create_booking(user_id, booking_params)
{:ok, "5c16bda3-d637-4790-b073-7fc00d9b3fea"}

> Flightex.update_booking(booking_id, user_id, booking_params)
{:ok, "5c16bda3-d637-4790-b073-7fc00d9b3fea"}
> Flightex.update_booking("SOFUNKY", user_id, booking_params)
{:error, "Booking not found."}

> Flightex.get_booking(booking_id)
{:ok,
 %Flightex.Bookings.Booking{
   departure: ~N[2014-03-04 23:59:59],
   going_to: "Tokyo",
   id: "5c16bda3-d637-4790-b073-7fc00d9b3fea",
   leaving_from: "LAX",
   user_id: "02cf4d12-38bc-46fe-9785-af179fd7053f"
 }}
> Flightex.get_booking("SOFUNKY")
{:error, "Booking not found."}
)> Flightex.get_bookings
%{
  "5c16bda3-d637-4790-b073-7fc00d9b3fea" => %Flightex.Bookings.Booking{
    departure: ~N[2014-03-04 23:59:59],
    going_to: "Tokyo",
    id: "5c16bda3-d637-4790-b073-7fc00d9b3fea",
    leaving_from: "LAX",
    user_id: "02cf4d12-38bc-46fe-9785-af179fd7053f"
  }
}
```

Bookings Report:

```elixir
> Flightex.start_agents()
> Flightex.Factory.build_list(4, :user_params) |>
> Stream.map(fn user_params -> Flightex.create_user(user_params) end) |>
> Enum.map(fn {:ok, user_id} -> Flightex.create_booking(user_id, Flightex.Factory.build(:booking_params)) end)
> Flightex.Factory.build_list(3, :user_params) |>
> Stream.map(fn user_params -> Flightex.create_user(user_params) end) |>
> Enum.map(fn {:ok, user_id} -> Flightex.create_booking(user_id, Flightex.Factory.build(:booking_params, departure: "2014-02-05 23:59:59")) end)
> Flightex.Factory.build_list(2, :user_params) |>
> Stream.map(fn user_params -> Flightex.create_user(user_params) end) |>
> Enum.map(fn {:ok, user_id} -> Flightex.create_booking(user_id, Flightex.Factory.build(:booking_params, departure: "2014-03-05 23:59:59")) end)
> Flightex.Factory.build_list(5, :user_params) |>
> Stream.map(fn user_params -> Flightex.create_user(user_params) end) |>
> Enum.map(fn {:ok, user_id} -> Flightex.create_booking(user_id, Flightex.Factory.build(:booking_params, departure: "2013-02-05 23:59:59")) end)
> Flightex.Bookings.Report.generate("2014-01-22 23:50:07", "2014-03-04 23:59:59")
{:ok, "Report succesfully created."}
> Flightex.Bookings.Report.generate("2014-01-22 23:50:07", "201-03-04 23:59:59")
{:error, :invalid_format}
> Flightex.Bookings.Report.generate("SOFUNKY", "2014-03-04 23:59:59")
{:error, :invalid_format}
```

`reports/bookings_report.csv`

```csv
4f1f3b7b-c953-4bbd-8718-1d1e01944ea7,LAX,Tokyo,2014-03-04 23:59:59
d681ceb8-c741-4872-aa12-af76960df125,LAX,Tokyo,2014-03-04 23:59:59
f4c78d33-8d52-4703-8f0e-dc9e11d72007,LAX,Tokyo,2014-03-04 23:59:59
75a17260-84bc-4a7d-a8e7-89e0706be2db,LAX,Tokyo,2014-03-04 23:59:59
eb93ff63-e66c-4275-bde3-8c8bf1fb9e11,LAX,Tokyo,2014-02-05 23:59:59
449cfc8c-d9c0-43ee-8576-037553f687f9,LAX,Tokyo,2014-02-05 23:59:59
4df01529-ba4f-4836-a82b-285bcb1755ca,LAX,Tokyo,2014-02-05 23:59:59

```

## Libs <a name = "libs"></a>

- https://github.com/rrrene/credo
- https://github.com/zyro/elixir-uuid
- https://github.com/bitwalker/timex
- https://github.com/thoughtbot/ex_machina

## Docs <a name = "docs"></a>

- https://elixir-lang.org/crash-course.html
- https://hexdocs.pm/elixir/NaiveDateTime.html#from_iso8601/2
- https://hexdocs.pm/elixir/Date.html#from_iso8601/2
- https://hexdocs.pm/elixir/Time.html#t:t/0
- https://hexdocs.pm/timex/getting-started.html
- https://hexdocs.pm/ex_machina/readme.html

## Resources <a name = "resources"></a>

- https://marketplace.visualstudio.com/items?itemName=pantajoe.vscode-elixir-credo
- https://stackoverflow.com/questions/51600416/elixir-add-timezone-data-to-naive-date-time
- https://stackoverflow.com/questions/40444970/how-to-convert-a-string-into-an-ecto-datetime-in-elixir
