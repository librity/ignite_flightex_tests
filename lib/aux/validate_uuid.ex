defmodule Flightex.Aux.ValidateUUID do
  def call(uuid) do
    case UUID.info(uuid) do
      {:ok, [{:uuid, valid_uuid} | _tails]} -> {:ok, valid_uuid}
      {:error, _reason} = error -> error
    end
  end
end
