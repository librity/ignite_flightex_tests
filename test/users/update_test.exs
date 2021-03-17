defmodule Flightex.Users.UpdateTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.User
  alias Flightex.Users.Create
  alias Flightex.Users.Update

  describe "call/2" do
    setup do
      UserAgent.start_link()

      {:ok, user_id} =
        build(:user_params)
        |> Create.call()

      {:ok, user_id: user_id}
    end

    test "should update the user and return its id", %{user_id: user_id} do
      new_params =
        build(:user_params, name: "Jesse James", email: "jesse@younger.org", cpf: "632-645-5215")

      return = Update.call(user_id, new_params)

      expected_user = %User{
        cpf: "632-645-5215",
        email: "jesse@younger.org",
        id: user_id,
        name: "Jesse James"
      }

      assert {:ok, returned_id} = return
      assert user_id == returned_id
      assert {:ok, updated_user} = UserAgent.get(user_id)
      assert expected_user == updated_user
    end

    test "should return an error when params aren't valid", %{user_id: user_id} do
      new_params = build(:user_params, name: 1234)

      return = Update.call(user_id, new_params)

      assert {:error, "Invalid params."} == return
    end

    test "should return an error when user doesn't exist" do
      new_params =
        build(:user_params, name: "Jesse James", email: "jesse@younger.org", cpf: "632-645-5215")

      return = Update.call(UUID.uuid4(), new_params)

      assert {:error, "User not found."} == return
    end
  end
end
