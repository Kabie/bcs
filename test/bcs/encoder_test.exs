defmodule Bcs.EncoderTest do
  use ExUnit.Case

  import Bcs.Encoder, only: [encode: 2]

  test "Booleans and Integers" do
    assert encode(true, :boolean) == <<0x01>>
    assert encode(false, :boolean) == <<0x00>>

    assert_raise ArgumentError, fn ->
      encode(1, :boolean)
    end
  end

end
