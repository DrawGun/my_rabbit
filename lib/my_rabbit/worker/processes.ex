defmodule MyRabbit.Worker.Processes do
  require Logger

  def process(socket, {:greeting, :producer}) do
    MyRabbit.Managers.SubscriptionManager.subscribe(socket, :producer)
    write_line(socket, "{\"status\": \"ok\"}")
  end

  def process(socket, {:greeting, :cunsumer}) do
    MyRabbit.Managers.SubscriptionManager.subscribe(socket, :cunsumer)
    write_line(socket, "{\"status\": \"ok\"}")
    write_line(socket, "{\"available queues\": #{inspect(MyRabbit.queues())}}")
  end

  def process(socket, {:subscribe, queues}) do
    case MyRabbit.Managers.SubscriptionManager.state().cunsumers
         |> Enum.member?(socket) do
      true ->
        MyRabbit.Managers.QueueManager.subscribe(socket, queues)
        write_line(socket, "{\"status\": \"ok\"}")

      response ->
        write_line(socket, "{\"not subscribed\": #{inspect(socket)}}")
    end
  end

  def process(socket, {:produce, queue, message}) do
    case MyRabbit.Managers.SubscriptionManager.state().producers
         |> Enum.member?(socket) do
      true ->
        MyRabbit.Managers.QueueManager.get_subscribers(queue)
        |> Enum.each(fn sub_socket ->
          write_line(sub_socket, "{\"message\": \"#{message}\", \"queue\": \"#{queue}\"}")
        end)

        write_line(socket, "{\"status\": \"ok\"}")

      response ->
        write_line(socket, "{\"not subscribed\": #{inspect(socket)}}")
    end
  end

  def process(socket, {:exit, message}) do
    MyRabbit.Managers.SubscriptionManager.unsubscribe(socket)
    MyRabbit.Managers.QueueManager.unsubscribe(socket)
    write_line(socket, message)
    :gen_tcp.close(socket)
  end

  def process(socket, {:wrong_command, message}), do: write_line(socket, message)

  def read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    Logger.info("Socket #{inspect(socket)} Data #{data}.")
    data
  end

  def write_line(socket, line) do
    :gen_tcp.send(socket, line <> "\n")
  end
end
