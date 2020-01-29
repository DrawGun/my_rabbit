defmodule MyRabbit.Task do
  use Task

  def start_link(socket) do
    Task.start_link(__MODULE__, :run, [socket])
  end

  def run(socket) do
    MyRabbit.Worker.accept_and_serve(socket)
  end
end
