defmodule Flightex.Aux.ValidateUUIDTest do
  use ExUnit.Case

  alias Flightex.Aux.ValidateUUID

  describe "call/1" do
    test "should return :ok and uuid when uuid is valid" do
      uuid4 = UUID.uuid4()

      assert {:ok, valid_uuid} = ValidateUUID.call(uuid4)
      assert uuid4 == valid_uuid
    end
  end
end
