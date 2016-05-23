defmodule StackServer do
  def start(state \\ []) do
    spawn(__MODULE__, :init, state)
  end

  def init(state) do
    loop(state)
  end

  def push(pid, value) do
    cast(pid, {:push, value})
  end

  def pop(pid) do
    call(pid, :pop)
  end

  def cast(pid, message) do
    send(pid, {:async, message})
    :ok
  end

  def call(pid, message) do
    ref = make_ref()
    send(pid, {:sync, message, {self(), ref}})
    receive do
      {^ref, reply} ->
        reply
    after 5000 ->
        exit(:timeout)
    end
  end

  def loop(state) do
    receive do
      {:async, message} ->
        case handle_cast(message, state) do
          {:noreply, new_state} ->
            loop(new_state)
        end
      {:sync, message, {sender, ref} = info} ->
        case handle_call(message, info, state) do
          {:reply, reply, new_state} ->
            send(sender, {ref, reply})
            loop(new_state)
        end
    end
  end

  def handle_cast({:push, value}, state) do
    {:noreply, [value | state]}
  end
  def handle_call(:pop, _from, []), do: {:reply, nil, []}
  def handle_call(:pop, _from, [head | rest]), do: {:reply, head, rest}
end
