defmodule MyRabbit.Supervisors.QueueSupervisor do
  use Supervisor
  require Logger

  def start_link(queue_list) do
    Supervisor.start_link(__MODULE__, queue_list, name: __MODULE__)
  end

  @impl true
  def init(queue_list) do
    Logger.info("Initializing Queues")

    children = prepare_queues_children(queue_list)

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp prepare_queues_children(queue_list) do
    queue_list
    |> Enum.map(fn queue_name ->
      %{
        id: queue_name,
        start: {MyRabbit.Queue, :start_link, [%{name: queue_name, subscribers: []}]}
      }
    end)
  end
end
