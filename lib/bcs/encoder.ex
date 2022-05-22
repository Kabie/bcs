defmodule Bcs.Encoder do

  @doc """
  Encode value to specific types.
  """
  def encode(value, type)

  def encode(true, :boolean), do: <<0x01>>
  def encode(false, :boolean), do: <<0x00>>

  def encode(value, type) do
    raise ArgumentError, "Can't encode #{inspect(value)} as #{inspect(type)}"
  end

end
