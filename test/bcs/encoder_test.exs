defmodule Bcs.EncoderTest do
  use ExUnit.Case

  import Bcs.Encoder, only: [encode: 2, uleb128: 1]

  test "Booleans and Integers" do
    assert encode(true, :bool) == <<0x01>>
    assert encode(false, :bool) == <<0x00>>

    assert_raise ArgumentError, fn ->
      encode(1, :bool)
    end

    assert encode(-1, :s8) == <<0xFF>>
    assert encode(1, :u8) == <<0x01>>

    assert encode(-0x1234, :s16) == <<0xCC, 0xED>>
    assert encode(0x1234, :u16) == <<0x34, 0x12>>

    assert encode(-0x1234_5678, :s32) == <<0x88, 0xA9, 0xCB, 0xED>>
    assert encode(0x1234_5678, :u32) == <<0x78, 0x56, 0x34, 0x12>>

    assert encode(-0x1234_5678_ABCD_EF00, :s64) ==
             <<0x00, 0x11, 0x32, 0x54, 0x87, 0xA9, 0xCB, 0xED>>

    assert encode(0x1234_5678_ABCD_EF00, :u64) ==
             <<0x00, 0xEF, 0xCD, 0xAB, 0x78, 0x56, 0x34, 0x12>>

    assert encode(-0x1234_5678_ABCD_EF00_1234_5678_ABCD_EF00, :s128) ==
             <<0x00, 0x11, 0x32, 0x54, 0x87, 0xA9, 0xCB, 0xED, 0xFF, 0x10, 0x32, 0x54, 0x87, 0xA9,
               0xCB, 0xED>>

    assert encode(0x1234_5678_ABCD_EF00_1234_5678_ABCD_EF00, :u128) ==
             <<0x00, 0xEF, 0xCD, 0xAB, 0x78, 0x56, 0x34, 0x12, 0x00, 0xEF, 0xCD, 0xAB, 0x78, 0x56,
               0x34, 0x12>>

    assert encode(0x7F, :s8) == <<0x7F>>

    assert_raise ArgumentError, fn ->
      encode(0x80, :s8)
    end

    assert encode(0xFFFF, :u16) == <<0xFF, 0xFF>>

    assert_raise ArgumentError, fn ->
      encode(0x1_0000, :u16)
    end
  end

  test "ULEB128" do
    assert uleb128(0x0000_0001) == <<0x01>>
    assert uleb128(0x0000_0080) == <<0x80, 0x01>>
    assert uleb128(0x0000_4000) == <<0x80, 0x80, 0x01>>
    assert uleb128(0x0020_0000) == <<0x80, 0x80, 0x80, 0x01>>
    assert uleb128(0x1000_0000) == <<0x80, 0x80, 0x80, 0x80, 0x01>>
    assert uleb128(0x0000_250F) == <<0x8F, 0x4A>>

    assert_raise ArgumentError, fn ->
      uleb128(0x1_0000_0000_0000_0000)
    end
  end

  test "Strings" do
    assert encode("", :string) == <<0x00>>

    assert encode("çå∞≠¢õß∂ƒ∫", :string) ==
             <<24, 0xC3, 0xA7, 0xC3, 0xA5, 0xE2, 0x88, 0x9E, 0xE2, 0x89, 0xA0, 0xC2, 0xA2, 0xC3,
               0xB5, 0xC3, 0x9F, 0xE2, 0x88, 0x82, 0xC6, 0x92, 0xE2, 0x88, 0xAB>>

    assert encode('abc', [:u8]) == <<3, ?a, ?b, ?c>>
  end

  test "Option" do
    assert encode(nil, [:u8 | nil]) == <<0x00>>

    assert encode(8, [:u8 | nil]) == <<0x01, 0x08>>
  end

  test "Lists" do
    assert encode([1, 2, 3], [:u16 | 3]) == <<1, 0, 2, 0, 3, 0>>

    assert encode([1, 2], [:u16]) == <<2, 1, 0, 2, 0>>
  end

  test "Tuples" do
    assert encode({-1, "diem"}, {:s8, :string}) == <<0xFF, 4, ?d, ?i, ?e, ?m>>
  end

  test "Maps" do
    assert encode(%{?e => ?f, ?a => ?b, ?c => ?d}, %{:u8 => :u8}) == <<3, ?a, ?b, ?c, ?d, ?e, ?f>>
  end
end
