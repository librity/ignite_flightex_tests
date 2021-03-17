defmodule Flightex.Users.UserTest do
  use ExUnit.Case

  alias Flightex.Aux.ValidateUUID
  alias Flightex.Users.User

  describe "build/4" do
    test "should return a user when params are valid" do
      return = User.build("The Dude", "thedude@abides.zen", "1234567")

      assert {:ok, %User{id: uuid, name: _name, email: _email, cpf: _cpf}} = return
      assert {:ok, _valid_uuid} = ValidateUUID.call(uuid)
    end

    test "should return a user with passed uuid" do
      passed_uuid = UUID.uuid4()
      return = User.build("The Dude", "thedude@abides.zen", "1234567", passed_uuid)

      assert {:ok, %User{id: uuid, name: _name, email: _email, cpf: _cpf}} = return
      assert passed_uuid == uuid
    end

    test "should return an error when uuid isn't valid" do
      bad_uuid = "SOFUNKY"
      return = User.build("The Dude", "thedude@abides.zen", "1234567", bad_uuid)

      expected = {:error, "Invalid id."}

      assert expected == return
    end

    test "should return an error when name isn't a bitstring" do
      return = User.build(123, "thedude@abides.zen", "1234567")

      expected = {:error, "Invalid params."}

      assert expected == return
    end

    test "should return an error when email isn't a bitstring" do
      return = User.build("The Dude", 123, "1234567")

      expected = {:error, "Invalid params."}

      assert expected == return
    end

    test "should return an error when cpf isn't a bitstring" do
      return = User.build("The Dude", "thedude@abides.zen", 1_234_567)

      expected = {:error, "Invalid params."}

      assert expected == return
    end
  end
end
