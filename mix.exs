defmodule IP2Country.Mixfile do
  use Mix.Project

  def project do
    [app: :ip2country,
     version: "1.2.0",
     elixir: "~> 1.4",
     description: description(),
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.18", only: :dev, runtime: false},
      {:benchfella, "~> 0.3.0", only: :dev}
    ]
  end

  defp description() do
    """
    IP -> Country Code converted with built-in database.
    """
  end

  defp package() do
    [
      name: :ip2country,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Tomek Gryszkiewicz"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/grych/ip2country",
        "Home" => "https://github.com/grych/ip2country"
      }
    ]
  end
end
