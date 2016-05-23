defmodule StackServer do
  def init(state) do
    {:ok, state}
  end
  def pop(pid) do
    ClumsyGenServer.call(pid, :pop)
  end
  def push(pid, value) do
    ClumsyGenServer.cast(pid, {:push, value})
  end
  def handle_cast({:push, value}, state) do
    {:noreply, [value | state]}
  end
  def handle_call(:pop, _from, [head | rest]) do
    {:reply, head, rest}
  end
end
