defmodule MyStruct do
  @derive {Bcs.Struct,
    label: :string,
    chars: [:u8 | 4],
    boolean: :boolean,
  }

  defstruct [:boolean, :chars, :label, :unused]
end

defmodule Wrapper do
  @derive {Bcs.Struct,
    name: :string,
    inner: MyStruct,
    maybe: [:s16 | nil]
  }

  defstruct [:inner, :name, :maybe]
end

defmodule Bcs.StructTest do
  use ExUnit.Case

  test "Encode structs" do
    my_struct = %MyStruct{
      label: "Hello",
      boolean: true,
      chars: 'abcd',
      unused: :whatever,
    }

    wrapper = %Wrapper{
      inner: my_struct,
      name: "Wrpped Mystruct",
      maybe: nil,
    }

    assert Bcs.Struct.encode(wrapper) == Bcs.Encoder.encode(
      {"Wrpped Mystruct", "Hello", 'abcd', true, nil},
      {:string, :string, [:u8 | 4], :boolean, [:s16 | nil]}
    )
  end

end
