defmodule StackServer do
  def start(state \\ []) do
   ClumsyGenServer.start(__MODULE__, state)
  end

  def init(state) do
    state
  end

  def push(pid, value) do
    ClumsyGenServer.cast(pid, {:push, value})
  end

  def pop(pid) do
    ClumsyGenServer.call(pid, :pop)
  end

  def handle_cast({:push, value}, state) do
    {:noreply, [value | state]}
  end
  def handle_call(:pop, _from, []), do: {:reply, nil, []}
  def handle_call(:pop, _from, [head | rest]), do: {:reply, head, rest}
end
