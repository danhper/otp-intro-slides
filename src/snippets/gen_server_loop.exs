defmodule ClumsyGenServer do
  def loop(module, state) do
    receive do
      {:async, message} ->
        {:noreply, new_state} = module.handle_cast(message, state)
        loop(module, new_state)
      {:sync, message, sender, ref} ->
        {:reply, reply, new_state} =
          module.handle_call(message, {sender, ref}, state)
        send(sender, {ref, reply})
        loop(module, new_state)
    end
  end
end
