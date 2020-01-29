defmodule MyRabbit.Worker.Commands do
  def match_to_command("EXIT"), do: {:exit, "Bye!"}

  def match_to_command(line) do
    case Jason.decode(line) do
      {:ok, command} ->
        match(command)

      {:error, %Jason.DecodeError{data: _data, position: _, token: _}} ->
        {:wrong_command, "Wrong command: #{inspect(line)}"}
    end
  end

  defp match(%{"command" => "hello", "type" => "producer"}) do
    {:greeting, :producer}
  end

  defp match(%{"command" => "hello", "type" => "cunsumer"}) do
    {:greeting, :cunsumer}
  end

  defp match(%{"subscribe" => queues}) do
    {:subscribe, queues}
  end

  defp match(%{"queue" => queue, "message" => message}) do
    {:produce, queue, message}
  end
end

# {"command": "hello", "type": "cunsumer"}
# {"subscribe": ["queue_1"]}
# {"command": "hello", "type": "producer"}
# {"queue": "queue_1", "message": "TEST"}
