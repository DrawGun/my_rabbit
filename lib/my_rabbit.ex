defmodule MyRabbit do
  use Application
  require Logger

  @queues %{"queue_1" => [], "queue_2" => []}

  def queues, do: Map.keys(@queues)

  def start(_type, port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Accepting connections on port #{port}")

    children = [
      {MyRabbit.Managers.QueueManager, []},
      {MyRabbit.Managers.SubscriptionManager, %{producers: [], cunsumers: []}},
      {MyRabbit.Supervisors.QueueSupervisor, queues()},
      {MyRabbit.Supervisors.NetworkSupervisor, socket}
    ]

    opts = [strategy: :one_for_one, name: MyRabbit.ApplicationSupervisor]
    Supervisor.start_link(children, opts)
  end
end
