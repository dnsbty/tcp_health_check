# TCP Health Check for Elixir
[![Hex Version](https://img.shields.io/hexpm/v/tcp_health_check.svg)](https://hex.pm/packages/tcp_health_check) [![Hex Docs](http://img.shields.io/badge/hex.pm-docs-green.svg?style=flat)](https://hexdocs.pm/tcp_health_check) [![CI Status](https://github.com/dnsbty/tcp_health_check/workflows/ci/badge.svg)](https://github.com/dnsbty/tcp_health_check/actions) [![MIT License](https://img.shields.io/hexpm/l/tcp_health_check)](https://opensource.org/licenses/MIT)

#### The easiest way to add a health check for your background services

This spins up a tiny TCP socket listener that will accept connections and then immediately close them. And do nothing else. It is especially useful for Kubernetes health checks for background worker pods, where you don't want to spin up a full web server to be able to tell the kubelet that your application is healthy.

## Installation

You can install TcpHealthCheck by adding `tcp_health_check` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tcp_health_check, "~> 0.1.0"}
  ]
end
```

Then you'll want to add it to your supervision tree. It should typically be the last child listed in your supervision tree so that it will be the final process to start up and the first one to be removed. You may wish to configure the port number to fit your needs. Otherwise it defaults to port `4321`:

```elixir
@impl true
def start(_type, _args) do
  children = [
    YourApp.Worker,
    {TcpHealthCheck, [port: 4321]}
  ]

  opts = [strategy: :one_for_one, name: Dockerized.Supervisor]
  Supervisor.start_link(children, opts)
end
```

Finally you can use this in Kubernetes by including a probe in your container specification:

```yaml
containers:
  - name: your_app
    ...
    readinessProbe:
      tcpSocket:
        port: 4321
      initialDelaySeconds: 2
      periodSeconds: 3
```

When the kubelet starts up your container, it will attempt to make a TCP connection to confirm readiness and the library will accept it for you to confirm that the application has started up as expected.

## License

TcpHealthCheck is released under the MIT License - see the [LICENSE](LICENSE) file.
