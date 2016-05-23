defmodule StackServer do
  def pop(pid) do
    ref = make_ref()
    send(pid, {:pop, self(), ref})
    receive do
      {^ref, value} -> value
    end
  end

  def loop(state) do
    receive do
      {:pop, sender, ref} ->
        [value | new_state] = state
        send(sender, {ref, value})
        loop(new_state)
    end
  end
end
