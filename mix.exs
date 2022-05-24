defmodule Bcs.MixProject do
  use Mix.Project

  def project do
    [
      app: :bcs,
      version: "0.1.0",
      elixir: "~> 1.13",
      consolidate_protocols: Mix.env() != :test,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end
