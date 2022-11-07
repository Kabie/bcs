defmodule Bcs.DecoderTest do
  use ExUnit.Case

  import Bcs.Decoder, only: [decode_value: 2, uleb128: 1]

  test "Booleans" do
    assert decode_value(<<0x01>>, :bool) == {true, ""}
    assert decode_value(<<0x00, "rest">>, :bool) == {false, "rest"}

    assert decode_value(<<0xFF>>, :bool) == :error
  end

  test "Integers" do
    assert decode_value(<<0xFF>>, :s8) == {-1, ""}
    assert decode_value(<<0x01>>, :u8) == {1, ""}

    assert decode_value(<<0xCC, 0xED>>, :s16) == {-0x1234, ""}
    assert decode_value(<<0x34, 0x12>>, :u16) == {0x1234, ""}

    assert decode_value(<<0x88, 0xA9, 0xCB, 0xED>>, :s32) == {-0x1234_5678, ""}
    assert decode_value(<<0x78, 0x56, 0x34, 0x12>>, :u32) == {0x1234_5678, ""}

    assert decode_value(<<0x00, 0x11, 0x32, 0x54, 0x87, 0xA9, 0xCB, 0xED>>, :s64) ==
             {-0x1234_5678_ABCD_EF00, ""}

    assert decode_value(<<0x00, 0xEF, 0xCD, 0xAB, 0x78, 0x56, 0x34, 0x12>>, :u64) ==
             {0x1234_5678_ABCD_EF00, ""}

    assert decode_value(
             <<0x00, 0x11, 0x32, 0x54, 0x87, 0xA9, 0xCB, 0xED, 0xFF, 0x10, 0x32, 0x54, 0x87, 0xA9,
               0xCB, 0xED>>,
             :s128
           ) ==
             {-0x1234_5678_ABCD_EF00_1234_5678_ABCD_EF00, ""}

    assert decode_value(
             <<0x00, 0xEF, 0xCD, 0xAB, 0x78, 0x56, 0x34, 0x12, 0x00, 0xEF, 0xCD, 0xAB, 0x78, 0x56,
               0x34, 0x12>>,
             :u128
           ) == {0x1234_5678_ABCD_EF00_1234_5678_ABCD_EF00, ""}

    assert decode_value(<<0x7F>>, :s8) == {0x7F, ""}

    assert decode_value(<<>>, :u8) == :error
  end

  test "ULEB128" do
    assert uleb128(<<0x01>>) == {0x0000_0001, ""}
    assert uleb128(<<0x80, 0x01>>) == {0x0000_0080, ""}
    assert uleb128(<<0x80, 0x80, 0x01>>) == {0x0000_4000, ""}
    assert uleb128(<<0x80, 0x80, 0x80, 0x01>>) == {0x0020_0000, ""}
    assert uleb128(<<0x80, 0x80, 0x80, 0x80, 0x01>>) == {0x1000_0000, ""}
    assert uleb128(<<0x8F, 0x4A>>) == {0x0000_250F, ""}

    assert uleb128(0x1_0000_0000_0000_0000) == :error
  end

  test "Strings" do
    assert decode_value(<<0x00>>, :string) == {"", ""}

    assert decode_value(
             <<24, 0xC3, 0xA7, 0xC3, 0xA5, 0xE2, 0x88, 0x9E, 0xE2, 0x89, 0xA0, 0xC2, 0xA2, 0xC3,
               0xB5, 0xC3, 0x9F, 0xE2, 0x88, 0x82, 0xC6, 0x92, 0xE2, 0x88, 0xAB>>,
             :string
           ) ==
             {"çå∞≠¢õß∂ƒ∫", ""}

    assert decode_value(<<3, ?a, ?b, ?c>>, [:u8]) == {'abc', ""}
  end

  test "Option" do
    assert decode_value(<<0x00>>, [:u8 | nil]) == {nil, ""}

    assert decode_value(<<0x01, 0x08>>, [:u8 | nil]) == {8, ""}
  end

  test "Lists" do
    assert decode_value(<<1, 0, 2, 0, 3, 0>>, [:u16 | 3]) == {[1, 2, 3], ""}

    assert decode_value(<<2, 1, 0, 2, 0>>, [:u16]) == {[1, 2], ""}
  end

  test "Tuples" do
    assert decode_value(<<0xFF, 4, ?d, ?i, ?e, ?m>>, {:s8, :string}) == {{-1, "diem"}, ""}
  end

  test "Maps" do
    assert decode_value(<<3, ?a, ?b, ?c, ?d, ?e, ?f>>, %{:u8 => :u8}) == {%{?e => ?f, ?a => ?b, ?c => ?d}, ""}
  end
end
