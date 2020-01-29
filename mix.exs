defmodule MyRabbit.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_rabbit,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {MyRabbit, 4444},
      extra_applications: [:logger, :poolboy]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poolboy, "~> 1.5"},
      {:jason, "~> 1.1"}
    ]
  end
end
