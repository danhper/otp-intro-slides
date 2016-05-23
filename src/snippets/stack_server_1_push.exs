defmodule StackServer do
  def push(pid, value) do
    send(pid, {:push, value})
  end
end
