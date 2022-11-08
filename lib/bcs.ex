defmodule Bcs do
  @moduledoc """
  BCS format.
  """

  @doc """
  Encode an BCS struct.
  """
  @spec encode(value :: struct()) :: {:ok, binary()} | :error
  def encode(%module{} = value) do
    {:ok, Bcs.Encoder.encode(value, module)}
  rescue _ ->
    :error
  end

  @doc """
  Same as encode/1, but raises ArgumentError.
  """
  @spec encode!(value :: struct()) :: binary()
  def encode!(%module{} = value) do
    Bcs.Encoder.encode(value, module)
  end

  @doc """
  Encode an BCS value to type.
  """
  @spec encode(value :: term(), type :: term()) :: {:ok, binary()} | :error
  def encode(value, type) do
    {:ok, Bcs.Encoder.encode(value, type)}
  rescue _ ->
    :error
  end

  @doc """
  Same as encode/2, but raises ArgumentError.
  """
  @spec encode!(value :: term(), type :: term()) :: binary()
  defdelegate encode!(value, type), to: Bcs.Encoder, as: :encode

  @doc """
  Decode bytes as BCS type.
  """
  @spec decode(bytes :: binary(), type :: term()) :: {:ok, term()} | :error
  defdelegate decode(bytes, type), to: Bcs.Decoder

  @doc """
  Same as decode/2, but raises ArgumentError.
  """
  @spec decode!(bytes :: binary(), type :: term()) :: term()
  def decode!(bytes, type) do
    case Bcs.Decoder.decode(bytes, type) do
      {:ok, value} ->
        value
      :error ->
        raise ArgumentError, "Can't decode #{inspect(bytes)} as #{inspect(type)}"
    end
  end
end
