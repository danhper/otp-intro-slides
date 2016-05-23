defmodule ClumsyGenServer do
  def start(module, state) do
    spawn(__MODULE__, :init, [module, state])
  end

  def init(module, state) do
    state = module.init(state)
    loop(module, state)
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

  def loop(module, state) do
    receive do
      {:async, message} ->
        case module.handle_cast(message, state) do
          {:noreply, new_state} ->
            loop(module, new_state)
        end
      {:sync, message, {sender, ref} = info} ->
        case module.handle_call(message, info, state) do
          {:reply, reply, new_state} ->
            send(sender, {ref, reply})
            loop(module, new_state)
        end
    end
  end
end
