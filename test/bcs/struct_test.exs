defmodule MyStruct do
  @derive {Bcs.Struct, label: :string, chars: [:u8 | 4], boolean: :bool}

  defstruct [:boolean, :chars, :label, :unused]
end

defmodule Wrapper do
  @derive {Bcs.Struct, name: :string, inner: MyStruct, maybe: [:s16 | nil]}

  defstruct [:inner, :name, :maybe]
end

defmodule Bcs.StructTest do
  use ExUnit.Case

  setup do
    my_struct = %MyStruct{
      label: "Hello",
      boolean: true,
      chars: 'abcd',
      unused: :whatever
    }

    wrapper = %Wrapper{
      inner: my_struct,
      name: "Wrpped Mystruct",
      maybe: nil
    }

    {:ok, wrapper: wrapper}
  end

  test "Encode structs", %{wrapper: wrapper} do
    assert Bcs.Struct.encode(wrapper) ==
             Bcs.Encoder.encode(
               {"Wrpped Mystruct", "Hello", 'abcd', true, nil},
               {:string, :string, [:u8 | 4], :bool, [:s16 | nil]}
             )
  end

  test "Decode structs", %{wrapper: wrapper} do
    encoded_then_decoded = wrapper |> Bcs.encode() |> Bcs.decode(Wrapper)
    assert put_in(wrapper.inner.unused, nil) == encoded_then_decoded
  end
end
