# Use gen_tcp to implement message passing system with traditional client-server networking model.

# Implement server process that listens and accepts new connections.
# Implement client process that connects to the server and has interface to send a (text) message to the server.
# When server receives the message from client, it echoes the message to all other connected clients.
# Clients waits and shows messages from server.
# Manually test your implementation with at least two clients.

# Bonus:

# Allow client to assign a name to itself after its connected to the server.
# When message is passed to other clients, show the name of the message originator.

defmodule ChatServer.Clients do
  use Agent

  def start_link() do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def get_others(client) do
    Agent.get(__MODULE__, fn clients -> List.delete(clients, client) end)
  end

  def add(client) do
    Agent.update(__MODULE__, fn clients -> [client | clients] end)
  end

  def remove(client) do
    Agent.update(__MODULE__, fn clients -> List.delete(clients, client) end)
  end
end

defmodule ChatServer do
  require Logger

  def start() do
    children = [
      {Task.Supervisor, name: ChatServer.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> accept(4040) end}, restart: :permanent)
    ]

    ChatServer.Clients.start_link()

    opts = [strategy: :one_for_one, name: ChatServer.Supervisor]

    Supervisor.start_link(children, opts)
  end

  def accept(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Listening on port #{port}")
    loop_accept(socket)
  end

  defp loop_accept(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(ChatServer.TaskSupervisor, fn -> serve(client) end)

    :ok = :gen_tcp.controlling_process(client, pid)

    ChatServer.Clients.add(client)

    Logger.info("Accepted client #{inspect(client)}")
    loop_accept(socket)
  end

  defp serve(socket, name \\ "anon") do
    socket
    |> read_line()
    |> String.trim()
    |> String.split(":", parts: 2)
    |> case do
      ["name", name] -> serve(socket, name)
      ["msg", msg] -> broadcast(socket, msg, name)
      _ -> :ok
    end

    serve(socket, name)
  end

  defp broadcast(socket, msg, name) do
    Logger.info("Broadcasting #{msg} from #{name} for socket #{inspect(socket)}")

    ChatServer.Clients.get_others(socket)
    |> Enum.each(fn client -> write_line("#{name}: #{msg}\n", client) end)
  end

  defp read_line(socket) do
    {:ok, line} = :gen_tcp.recv(socket, 0)
    line
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
