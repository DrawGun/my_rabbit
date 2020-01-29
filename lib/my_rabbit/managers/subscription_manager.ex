defmodule MyRabbit.Managers.SubscriptionManager do
  use GenServer
  require Logger

  def start_link(state) do
    Logger.info("Starting NetworkManager")
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state), do: {:ok, state}

  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:subscribe_producer, socket}, state) do
    {:noreply, Map.put(state, :producers, [socket | state.producers])}
  end

  # Надо сделать уникальность
  def handle_cast({:subscribe_cunsumer, socket}, state) do
    {:noreply, Map.put(state, :cunsumers, [socket | state.cunsumers])}
  end

  def handle_cast({:unsubscribe, socket}, state) do
    state = %{
      producers: List.delete(state.producers, socket),
      cunsumers: List.delete(state.cunsumers, socket)
    }

    {:noreply, state}
  end

  def state(), do: GenServer.call(__MODULE__, {:get_state})
  def subscribe(socket, :producer), do: GenServer.cast(__MODULE__, {:subscribe_producer, socket})
  def subscribe(socket, :cunsumer), do: GenServer.cast(__MODULE__, {:subscribe_cunsumer, socket})
  def unsubscribe(socket), do: GenServer.cast(__MODULE__, {:unsubscribe, socket})
end
