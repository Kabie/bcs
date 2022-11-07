defmodule Bcs.TaggedEnum do
  @moduledoc """
  Use this module to define a tagged enum.
  """

  defmacro __using__(variants) do
    variants
    |> Enum.with_index(fn
      tagged, index ->
        tag = Bcs.Encoder.uleb128(index)

        case tagged do
          {variant_tag, type} ->
            quote do
              def encode({unquote(variant_tag), value}) do
                unquote(tag) <> Bcs.Encoder.encode(value, unquote(type))
              end

              def decode(unquote(tag) <> rest) do
                with {value, rest} <- Bcs.Decoder.decode_value(rest, unquote(type)) do
                  {{unquote(variant_tag), value}, rest}
                end
              end
            end

          variant_tag ->
            quote do
              def encode(unquote(variant_tag)) do
                unquote(tag)
              end

              def decode(unquote(tag) <> rest) do
                {unquote(variant_tag), rest}
              end
            end
        end
    end)
  end
end
