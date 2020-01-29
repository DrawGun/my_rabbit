defmodule MyRabbit.Queue do
  use GenServer

  def queue_name(name) do
    String.to_atom("#{String.capitalize(name)}")
  end

  def start_link(state) do
    IO.puts("MyRabbit.Queue name is #{queue_name(state.name)}")
    GenServer.start_link(__MODULE__, state, name: queue_name(state.name))
  end

  def init(state), do: {:ok, state}

  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:subscribe, socket}, state) do
    {:noreply, Map.put(state, :subscribers, [socket | state.subscribers])}
  end

  def handle_cast({:unsubscribe, socket}, state) do
    {:noreply, Map.put(state, :subscribers, List.delete(state.subscribers, socket))}
  end

  def state(queue), do: GenServer.call(queue_name(queue), {:get_state})
  def subscribe(queue, socket), do: GenServer.cast(queue_name(queue), {:subscribe, socket})
  def unsubscribe(queue, socket), do: GenServer.cast(queue_name(queue), {:unsubscribe, socket})
end
