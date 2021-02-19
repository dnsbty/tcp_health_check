defmodule TcpHealthCheckTest do
  use ExUnit.Case
  doctest TcpHealthCheck

  @tcp_opts [:binary, active: false]

  test "accepts incoming TCP connections" do
    start_supervised!(TcpHealthCheck)
    assert {:ok, _socket} = :gen_tcp.connect('localhost', 4321, @tcp_opts)
  end

  test "uses the specified port" do
    start_supervised!({TcpHealthCheck, [port: 20493]})
    assert {:ok, _socket} = :gen_tcp.connect('localhost', 20493, @tcp_opts)
  end
end
