defmodule PhoenixActiveLink.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [app: :phoenix_active_link,
     version: @version,
     name: "phoenix_active_link",
     source_url: "http://github.com/tuvistavie/phoenix-active-link",
     homepage_url: "http://github.com/tuvistavie/phoenix-active-link",
     package: package,
     description: ~S(Phoenix view helper to manage "active" state of a link),
     elixir: "~> 1.1",
     deps: deps,
     docs: [source_ref: "#{@version}", extras: ["README.md"], main: "readme"]]
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Daniel Perez"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/tuvistavie/phoenix-active-link",
               "Docs" => "http://hexdocs.pm/phoenix_active_link/"}]
  end

  defp deps do
    [{:phoenix_html, "~> 2.5"},

     {:earmark, "~> 0.1", only: :docs},
     {:ex_doc, "~> 0.11", only: :docs}]
  end
end
