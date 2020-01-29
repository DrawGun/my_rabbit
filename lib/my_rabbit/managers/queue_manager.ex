defmodule MyRabbit.Managers.QueueManager do
  use GenServer
  require Logger

  def start_link(state) do
    Logger.info("Starting QueueManager")
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state), do: {:ok, state}

  def handle_call({:get_subscribers, queue}, _from, state) do
    {:reply, GenServer.call(queue_name(queue), {:get_state}).subscribers, state}
  end

  def handle_cast({:subscribe, socket, queues}, state) do
    queues
    |> Enum.each(fn queue -> MyRabbit.Queue.subscribe(queue, socket) end)

    {:noreply, state}
  end

  def handle_cast({:unsubscribe, socket}, state) do
    MyRabbit.queues()
    |> Enum.each(fn queue -> MyRabbit.Queue.unsubscribe(queue, socket) end)

    {:noreply, state}
  end

  def get_subscribers(queue), do: GenServer.call(__MODULE__, {:get_subscribers, queue})
  def subscribe(socket, queues), do: GenServer.cast(__MODULE__, {:subscribe, socket, queues})
  def unsubscribe(socket), do: GenServer.cast(__MODULE__, {:unsubscribe, socket})

  def queue_name(name) do
    String.to_atom("#{String.capitalize(name)}")
  end
end
