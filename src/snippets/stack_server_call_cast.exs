defmodule ClumsyGenServer do
  def cast(pid, message) do
    send(pid, {:async, message})
  end

  def call(pid, message) do
    ref = make_ref()
    send(pid, {:sync, message, self(), ref})
    receive do
      {^ref, reply} -> reply
    end
  end
end
