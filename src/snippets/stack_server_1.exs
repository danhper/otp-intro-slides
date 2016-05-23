defmodule StackServer do
  def loop(state) do
    receive do
      {:push, value} ->
        new_state = [value | state]
        loop(new_state)
      {:pop, sender} ->
        [value | new_state] = state
        send(sender, value)
        loop(new_state)
    end
  end
end
