defmodule Bcs.EncoderTest do
  use ExUnit.Case

  import Bcs.Encoder, only: [encode: 2]

  test "Booleans and Integers" do
    assert encode(true, :boolean) == <<0x01>>
    assert encode(false, :boolean) == <<0x00>>

    assert_raise ArgumentError, fn ->
      encode(1, :boolean)
    end

    assert encode(-1, :s8) == <<0xFF>>
    assert encode(1, :u8) == <<0x01>>

    assert encode(-4660, :s16) == <<0xCC, 0xED>>
    assert encode(4660, :u16) == <<0x34, 0x12>>

    assert encode(-305419896, :s32) == <<0x88, 0xA9, 0xCB, 0xED>>
    assert encode(305419896, :u32) == <<0x78, 0x56, 0x34, 0x12>>

    assert encode(-1311768467750121216, :s64) == <<0x00, 0x11, 0x32, 0x54, 0x87, 0xA9, 0xCB, 0xED>>
    assert encode(1311768467750121216, :u64) == <<0x00, 0xEF, 0xCD, 0xAB, 0x78, 0x56, 0x34, 0x12>>

    assert encode(-1311768467750121216, :s64) == <<0x00, 0x11, 0x32, 0x54, 0x87, 0xA9, 0xCB, 0xED>>
    assert encode(1311768467750121216, :u64) == <<0x00, 0xEF, 0xCD, 0xAB, 0x78, 0x56, 0x34, 0x12>>

    assert encode(127, :s8) == <<0x7F>>
    assert_raise ArgumentError, fn ->
      encode(128, :s8)
    end

    assert encode(65535, :u16) == <<0xFF, 0xFF>>
    assert_raise ArgumentError, fn ->
      encode(65536, :u16)
    end

  end

end
