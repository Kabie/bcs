defmodule Bcs.Encoder do
  import Bitwise, only: [<<<: 2]

  @doc """
  Encode value to specific types.
  """
  def encode(value, type)

  def encode(true, :boolean), do: <<0x01>>
  def encode(false, :boolean), do: <<0x00>>

  for bit <- [8, 16, 32, 64, 128] do
    def encode(value, unquote(:"s#{bit}")) when value >= unquote(-(1<<<bit-1)) and value < unquote(1<<<bit-1) do
      <<value::little-signed-unquote(bit)>>
    end

    def encode(value, unquote(:"u#{bit}")) when value >= 0 and value < unquote(1<<<bit) do
      <<value::little-unsigned-unquote(bit)>>
    end
  end

  def encode(value, type) do
    raise ArgumentError, "Can't encode #{inspect(value)} as #{inspect(type)}"
  end

end
