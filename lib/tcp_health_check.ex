defmodule TcpHealthCheck do
  @moduledoc """
  This spins up a tiny TCP socket listener that will accept connections and
  then immediately close them. And do nothing else.

  It is especially useful for Kubernetes health checks for background
  processes, where you don't want to spin up a full web server to be able to
  tell the kubelet that your application is healthy.

  It should typically be the last child listed in your supervision tree so that
  it will be the final process to start up and the first one to be removed.
  """

  @tcp_opts [:binary, packet: :line, active: false, reuseaddr: true]

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(opts) do
    port = Keyword.get(opts, :port, 4321)
    {:ok, listener} = :gen_tcp.listen(port, @tcp_opts)
    pid = spawn(fn -> loop_acceptor(listener) end)
    {:ok, pid}
  end

  defp loop_acceptor(listener) do
    {:ok, socket} = :gen_tcp.accept(listener)
    :gen_tcp.close(socket)
    loop_acceptor(listener)
  end
end
