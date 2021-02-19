defmodule TcpHealthCheck.MixProject do
  use Mix.Project

  @project_url "https://github.com/dnsbty/tcp_health_check"

  def project do
    [
      app: :tcp_health_check,
      version: "0.1.0",
      elixir: "~> 1.5",
      deps: deps(),

      # Docs
      name: "TCP Health Check",
      description: "The easiest way to add a health check for your background services",
      source_url: @project_url,
      docs: docs(),
      package: package()
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.23", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "TcpHealthCheck",
      api_reference: false,
      extras: ["README.md"]
    ]
  end

  defp package do
    [
      maintainers: ["Dennis Beatty"],
      licenses: ["MIT"],
      links: %{"GitHub" => @project_url}
    ]
  end
end
