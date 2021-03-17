defmodule Flightex.Users.AgentTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.User

  describe "save/1" do
    setup do
      UserAgent.start_link()

      :ok
    end

    test "should persist user in agent" do
      valid_user = build(:user)

      expected_user = %{
        valid_user.id => %User{
          cpf: "1234567",
          email: "iggy@murderbusiness.org",
          id: valid_user.id,
          name: "Iggy Azalea"
        }
      }

      assert :ok == UserAgent.save(valid_user)
      assert expected_user == Agent.get(Flightex.Users.Agent, & &1)
    end
  end

  describe "get/1" do
    setup do
      UserAgent.start_link()

      valid_user = build(:user)
      UserAgent.save(valid_user)

      {:ok, user_id: valid_user.id}
    end

    test "should return user by id", %{user_id: id} do
      expected =
        {:ok,
         %User{
           cpf: "1234567",
           email: "iggy@murderbusiness.org",
           id: id,
           name: "Iggy Azalea"
         }}

      assert expected == UserAgent.get(id)
    end

    test "should return an error when user doesn't exist" do
      expected = {:error, "User not found."}

      assert expected == UserAgent.get(UUID.uuid4())
    end
  end

  describe "get_all/0" do
    setup do
      UserAgent.start_link()

      users = build_list(3, :user)

      users
      |> Enum.map(fn user -> UserAgent.save(user) end)

      {:ok, users: users}
    end

    test "should return all users", %{users: users} do
      expected =
        users
        |> Enum.reduce(%{}, fn %User{id: user_id} = user, previous ->
          Map.put(previous, user_id, user)
        end)

      assert expected == UserAgent.get_all()
    end
  end
end
