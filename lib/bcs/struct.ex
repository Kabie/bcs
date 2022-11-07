defprotocol Bcs.Struct do
  @moduledoc """
  Derive this protocol to define a BCS struct.
  """

  @spec encode(value :: struct()) :: binary()
  def encode(value)
end

defimpl Bcs.Struct, for: Any do
  defmacro __deriving__(module, _struct, fields) do
    field_name = Keyword.keys(fields)

    fields_types =
      Keyword.values(fields)
      |> Macro.escape()

    fields_encode_calls =
      fields
      |> Enum.map(fn {name, type} ->
        type = Macro.escape(type)

        quote do
          var!(value)
          |> Map.get(unquote(name))
          |> Bcs.Encoder.encode(unquote(type))
        end
      end)

    quote do
      @enforce_keys unquote(field_name)

      defimpl Bcs.Struct, for: unquote(module) do
        def encode(var!(value)) do
          [unquote_splicing(fields_encode_calls)]
          |> IO.iodata_to_binary()
        end
      end

      def decode(bytes) do
        with {values, rest} <- Bcs.Decoder.decode_values(bytes, unquote(fields_types)) do
          {struct(unquote(module), Enum.zip(unquote(field_name), values)), rest}
        else
          _ -> :error
        end
      end
    end
  end

  def encode(_value) do
    throw(:not_implemented)
  end
end
