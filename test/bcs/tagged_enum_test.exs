defmodule Foo do
  use Bcs.TaggedEnum, [
    {:variant0, :u16},
    {:variant1, :u8},
    {:variant2, :string},
    :variant3
  ]
end

defmodule Bcs.TaggedEnumTest do
  use ExUnit.Case

  test "Encode tagged enums" do
    assert Bcs.Encoder.encode({:variant0, 8000}, Foo) == <<0x00, 0x40, 0x1F>>
    assert Bcs.Encoder.encode({:variant1, 255}, Foo) == <<0x01, 0xFF>>
    assert Bcs.Encoder.encode({:variant2, "variant2"}, Foo) == <<0x02, 8, "variant2">>
    assert Bcs.Encoder.encode(:variant3, Foo) == <<0x03>>
  end

  test "Decode tagged enums" do
    assert Bcs.Decoder.decode(<<0x00, 0x40, 0x1F>>, Foo) == {:ok, {:variant0, 8000}}
    assert Bcs.Decoder.decode(<<0x01, 0xFF>>, Foo) == {:ok, {:variant1, 255}}
    assert Bcs.Decoder.decode(<<0x02, 8, "variant2">>, Foo) == {:ok, {:variant2, "variant2"}}
    assert Bcs.Decoder.decode(<<0x03>>, Foo) == {:ok, :variant3}
  end
end
