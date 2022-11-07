defmodule Bcs.Decoder do

  def uleb128(<<0::1, value::7>> <> rest) do
    {value, rest}
  end

  def uleb128(<<1::1, b2::7, 0::1, b1::7>> <> rest) do
    <<value::14>> = <<b1::7, b2::7>>
    {value, rest}
  end

  def uleb128(<<1::1, b3::7, 1::1, b2::7, 0::1, b1::7>> <> rest) do
    <<value::21>> = <<b1::7, b2::7, b3::7>>
    {value, rest}
  end

  def uleb128(<<1::1, b4::7, 1::1, b3::7, 1::1, b2::7, 0::1, b1::7>> <> rest) do
    <<value::28>> = <<b1::7, b2::7, b3::7, b4::7>>
    {value, rest}
  end

  def uleb128(<<1::1, b5::7, 1::1, b4::7, 1::1, b3::7, 1::1, b2::7, 0::1, b1::7>> <> rest) do
    <<value::32>> = <<b1::4, b2::7, b3::7, b4::7, b5::7>>
    {value, rest}
  end

  def uleb128(_bytes) do
    :error
  end

  @doc """
  Decode `bytes` as `type`
  """
  @spec decode_value(bytes :: binary(), type :: term()) :: {term(), binary()} | :error
  def decode(bytes, type) do
    with {value, ""} <- decode_value(bytes, type) do
      value
    else
      _ -> :error
    end
  end

  def decode_value(<<0x01>> <> rest, :bool), do: {true, rest}
  def decode_value(<<0x00>> <> rest, :bool), do: {false, rest}


  for bit <- [8, 16, 32, 64, 128] do
    def decode_value(<<value::little-signed-unquote(bit)>> <> rest, unquote(:"s#{bit}")) do
      {value, rest}
    end

    def decode_value(<<value::little-unsigned-unquote(bit)>> <> rest, unquote(:"u#{bit}")) do
      {value, rest}
    end
  end

  def decode_value(bytes, :string) do
    with {len, rest} <- uleb128(bytes),
      <<value::binary-size(len)>> <> rest <- rest
    do
      {value, rest}
    else
      _ -> :error
    end
  end

  def decode_value(<<0x00>> <> rest, [_type | nil]) do
    {nil, rest}
  end

  def decode_value(<<0x01>> <> rest, [type | nil]) do
    decode_value(rest, type)
  end

  def decode_value(bytes, [type]) do
    with {len, rest} <- uleb128(bytes) do
      decode_values(rest, List.duplicate(type, len))
    else
      _ -> :error
    end
  end

  def decode_value(bytes, [type | size]) do
    decode_values(bytes, List.duplicate(type, size))
  end

  def decode_value(bytes, types) when is_tuple(types) do
    with {values, rest} <- decode_values(bytes, Tuple.to_list(types)) do
      {List.to_tuple(values), rest}
    end
  end


  def decode_value(bytes, type) when is_map(type) and map_size(type) == 1 do
    [{k_type, v_type}] = Map.to_list(type)
    with {values, rest} <- decode_value(bytes, [{k_type, v_type}]) do
      {Map.new(values), rest}
    else
      _ -> :error
    end
  end

  def decode_value(bytes, type) when is_atom(type) do
    if {:module, type} == Code.ensure_loaded(type) && function_exported?(type, :decode, 1) do
      type.decode(bytes)
    else
      :error
    end
  end

  def decode_value(_bytes, _type), do: :error


  def decode_values(bytes, types) do
    decode_values(bytes, types, [])
  end

  defp decode_values(rest, [], acc) do
    {Enum.reverse(acc), rest}
  end

  defp decode_values(bytes, [type | types], acc) do
    with {value, rest} <- decode_value(bytes, type) do
      decode_values(rest, types, [value | acc])
    end
  end

end
