defmodule Bcs do
  @moduledoc """
  Documentation for `Bcs`.
  """

  def encode(%module{} = value) do
    Bcs.Encoder.encode(value, module)
  end

  defdelegate encode(value, type), to: Bcs.Encoder
end
