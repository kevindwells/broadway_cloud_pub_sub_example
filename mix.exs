defmodule PubSubExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :broadway_cloud_pub_sub_example,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {PubSubExample.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:broadway_cloud_pub_sub, "~> 0.1.0"},
      {:goth, "~> 0.11"}
    ]
  end
end
