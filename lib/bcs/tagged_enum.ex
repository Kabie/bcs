defmodule Bcs.TaggedEnum do
  defmacro __using__(variants) do
    variants
    |> Enum.with_index(fn {variant, type}, index ->
      tag = Bcs.Encoder.uleb128(index)

      quote do
        def encode({unquote(variant), value}) do
          unquote(tag) <> Bcs.Encoder.encode(value, unquote(type))
        end
      end
    end)
  end
end
