defmodule Bcs.MixProject do
  use Mix.Project

  @version "0.2.0"
  @source_url "https://github.com/Kabie/bcs"

  def project do
    [
      app: :bcs,
      version: @version,
      description: description(),
      elixir: "~> 1.13",
      consolidate_protocols: Mix.env() != :test,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      source_url: @source_url
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Pure Elixir encoder/decoder for BCS format."
  end

  defp package do
    %{
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      }
    }
  end
end
