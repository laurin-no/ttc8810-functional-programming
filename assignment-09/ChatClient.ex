defmodule ChatClient do
  require Logger

  def connect(address, port) do
    {:ok, socket} = :gen_tcp.connect(address, port, [:binary, packet: :line, active: false])
    Logger.info("Connected to server")

    socket
    # loop(socket)
  end

  def listen(socket) do
    # {:ok, line} = :gen_tcp.recv(socket, 0)
    # Logger.info("Received: #{inspect(line)}")
    read_line(socket)

    listen(socket)
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end

  defp read_line(socket) do
    {:ok, line} = :gen_tcp.recv(socket, 0)
    IO.puts(line)
  end

  def send_msg(msg, socket) do
    write_line("msg:#{msg}\n", socket)
  end

  def set_name(name, socket) do
    write_line("name:#{name}\n", socket)
  end
end
