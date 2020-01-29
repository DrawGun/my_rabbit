defmodule MyRabbit.Worker do
  import MyRabbit.Worker.Commands
  import MyRabbit.Worker.Processes
  require Logger

  def accept_and_serve(socket) do
    Logger.info("Starter Worker #{inspect(self())}")

    {:ok, client} = :gen_tcp.accept(socket)
    write_line(client, "CONNECTED to worker #{inspect(self())}")
    serve(client)
    accept_and_serve(socket)
  end

  defp serve(socket) do
    command =
      socket
      |> read_line()
      |> String.trim()
      |> match_to_command()

    process(socket, command)

    serve(socket)
  end
end
