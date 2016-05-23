defmodule StackServer do
  def start do
    spawn(__MODULE__, :init, [])
  end

  def init(state \\ []) do
    loop(state)
  end

  def push(pid, value) do
    send(pid, {:push, value})
    :ok
  end

  def pop(pid) do
    ref = make_ref()
    send(pid, {:pop, self(), ref})
    receive do
      {^ref, value} -> value
    end
  end

  def loop(state) do
    receive do
      {:push, value} ->
        loop([value | state])
      {:pop, sender, ref} ->
        {value, new_state} =
          case state do
            [] -> {nil, state}
            [value | new_state] -> {value, new_state}
          end
        send(sender, {ref, value})
        loop(new_state)
    end
  end
end
