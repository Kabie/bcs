defmodule Bcs.Encoder do
  import Bitwise, only: [<<<: 2]

  @doc """
  Unsigned Little Endian Base 128.

  See https://en.wikipedia.org/wiki/LEB128#Unsigned_LEB128
  """
  def uleb128(value) when value >= 0 and value < unquote(1<<<7) do
    <<value::8>>
  end

  def uleb128(value) when value >= unquote(1<<<7) and value < unquote(1<<<14) do
    <<b1::7, b2::7>> = <<value::14>>
    <<1::1, b2::7, 0::1, b1::7>>
  end

  def uleb128(value) when value >= unquote(1<<<14) and value < unquote(1<<<21) do
    <<b1::7, b2::7, b3::7>> = <<value::21>>
    <<1::1, b3::7, 1::1, b2::7, 0::1, b1::7>>
  end

  def uleb128(value) when value >= unquote(1<<<21) and value < unquote(1<<<28) do
    <<b1::7, b2::7, b3::7, b4::7>> = <<value::28>>
    <<1::1, b4::7, 1::1, b3::7, 1::1, b2::7, 0::1, b1::7>>
  end

  def uleb128(value) when value >= unquote(1<<<28) and value < unquote(1<<<32) do
    <<b1::4, b2::7, b3::7, b4::7, b5::7>> = <<value::32>>
    <<1::1, b5::7, 1::1, b4::7, 1::1, b3::7, 1::1, b2::7, 0::1, b1::7>>
  end

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
