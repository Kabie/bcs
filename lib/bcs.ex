defmodule Bcs do
  @moduledoc """
  BCS format.
  """

  @doc """
  Encode an BCS struct.
  """
  def encode(%module{} = value) do
    Bcs.Encoder.encode(value, module)
  end

  @doc """
  Encode an BCS value to type.
  """
  defdelegate encode(value, type), to: Bcs.Encoder
end
