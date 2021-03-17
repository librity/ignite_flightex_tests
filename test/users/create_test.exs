defmodule Flightex.Users.CreateTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.Create

  describe "call/1" do
    setup do
      UserAgent.start_link()

      :ok
    end

    test "should create the user and return its id" do
      return =
        build(:user_params)
        |> Create.call()

      assert {:ok, user_id} = return
      assert {:ok, _user} = UserAgent.get(user_id)
    end

    test "should return an error when params aren't valid" do
      return =
        build(:user_params, name: 1234)
        |> Create.call()

      assert {:error, "Invalid params."} == return
    end
  end
end
