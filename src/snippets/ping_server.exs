defmodule PingServer do
  def start do
    spawn(__MODULE__, :loop, [])
  end

  def loop do
    receive do
      {:ping, sender} ->
        send(sender, :pong)
        loop()
    end
  end
end
