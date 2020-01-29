defmodule MyRabbit.Supervisors.NetworkSupervisor do
  use Supervisor
  require Logger

  def start_link(socket) do
    Supervisor.start_link(__MODULE__, socket, name: __MODULE__)
  end

  defp pool_name() do
    :worker
  end

  @impl true
  def init(socket) do
    Logger.info("Initializing Workers")

    poolboy_config = [
      {:name, {:local, pool_name()}},
      {:worker_module, MyRabbit.Task},
      {:size, 5},
      {:max_overflow, 1},
      {:strategy, :fifo}
    ]

    children = [
      :poolboy.child_spec(pool_name(), poolboy_config, socket)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
