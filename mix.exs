defmodule NorwegianIdNumber.MixProject do
  use Mix.Project

  def project do
    [
      app: :norwegian_id_number,
      version: "0.1.0",
      elixir: "~> 1.6",
      description: "Elixir library to parse and validate Norwegian national identification numbers",
      docs: [extras: ["README.md"]],
      build_embedded: Mix.env == :prod,
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env),
      deps: deps()
    ]
  end

  def package do
    [
      name: :norwegian_id_number,
      files: ["lib", "mix.exs"],
      maintainers: ["Vyacheslav Voronchuk"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/starbuildr/norwegian_id_number"},
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/stub_modules"]
  defp elixirc_paths(_), do: ["lib"]
end
